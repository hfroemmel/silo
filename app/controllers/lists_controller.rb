# The ListsController provides the actions to handle some list specific
# requests. See Ajax::LitsController to find more.
class ListsController < ApplicationController
  before_filter :check_password, only: :destroy
  before_filter :find_list,      only: [:update, :concat, :copy, :destroy]

  skip_before_filter :authorize

  cache_sweeper :list_sweeper, only: :update

  # Serves all lists.
  def index
    @lists = List.search(params).accessible_for(current_user).limit(50).page(params[:page])
    @title = t('labels.list.all')
  end

  # Creates a new list and sets the users current list.
  def create
    list = List.new_for_user(params[:list], current_user)

    if list.save
      flash[:notice] = t('messages.list.success.create', title: list.title)
      redirect_to list_experts_url(list)
    else
      flash[:alert] = t('messages.list.errors.create')
      redirect_to lists_url
    end
  end

  # Updates a list.
  def update
    if @list.update_attributes(params[:list])
      flash[:notice] = t('messages.list.success.save')
    else
      flash[:alert] = t('messages.list.errors.save')
    end

    redirect_to list_experts_url(@list)
  end

  # Concats a list with another.
  def concat
    other = List.find_for_user(params[:other], current_user)
    @list.concat(other)
    flash[:notice] = t('messages.list.success.concat', title: other.title)
    redirect_to list_experts_url(@list)
  end

  # Copies a list.
  def copy
    copy = @list.copy
    copy.attributes = params[:list]
    copy.user = current_user
    copy.private = true

    if copy.save
      flash[:notice] = t('messages.list.success.copy', title: @list.title)
      redirect_to list_experts_url(copy)
    else
      flash[:alert] = t('messages.list.errors.copy')
      redirect_to list_experts_url(@list)
    end
  end

  # Destroys a list.
  def destroy
    if @list.destroy
      flash[:notice] = t('messages.list.success.delete', title: @list.title)
      redirect_to lists_url
    else
      flash[:alert] = t('messages.list.errors.delete')
      redirect_to list_experts_url(@list)
    end
  end

  private

  # Finds the list.
  def find_list
    @list = List.find_for_user(params[:id], current_user)
  end

  # Sets a flash and redirects the user.
  def not_found
    flash[:alert] = t('messages.list.errors.find')
    redirect_to(@list ? list_experts_url(@list) : lists_url)
  end

  # Redirects to the lists index.
  def unauthorized
    super(lists_url)
  end
end

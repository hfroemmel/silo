#
class CvsController < ApplicationController
  before_filter :authorize, except: [:show]

  #
  def authorize
    unless current_user.access?(:experts)
      flash[:alert] = t('msg.access_denied')
      redirect_to expert_url(params[:expert_id])
    end
  end

  #
  def show
    cv = Cv.includes(:expert).find(params[:id])
    send_file cv.absolute_path, filename: cv.public_filename
  end

  def create
    begin
      expert = Expert.find(params[:expert_id])
    rescue
      flash[:alert] = t('msg.expert_not_found')
      redirect_to experts_url and return
    end

    unless (cv = Cv.from_file(params[:cv][:file]))
      flash[:alert] = t('msg.could_not_store_cv')
      redirect_to document_expert_url(expert) and return
    end

    begin
      cv.language = Language.find(params[:cv][:language_id])
    rescue
      flash[:alert] = t('msg.language_not_found')
      redirect_to document_expert_url(expert) and return
    end

    expert.cvs << cv
    flash[:notice] = t('msg.stored_new_cv')
  rescue
    flash[:alert] = t('msg.could_not_save_cv')
  ensure
    redirect_to documents_expert_url(expert)
  end

  def destroy
    cv = Cv.find(params[:id])

    if cv.destroy
      flash[:notice] = t('msg.deleted_cv')
    else
      flash[:alert] = t('msg.could_not_delete_cv')
    end

    redirect_to documents_expert_url(id: params[:expert_id])
  end

  # Sets an alert flash and redirect to the experts detail page.
  def not_found
    flash[:alert] = t('msg.cv_not_found')
    redirect_to expert_url(params[:expert_id])
  end
end

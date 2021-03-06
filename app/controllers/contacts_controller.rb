# The ContactsController the parent class of all Controllers in the Contacts
# module. It provides generic methods to manipulate the polymorphic Contact
# model.
class ContactsController < ApplicationController

  protected

  # Adds a contact to a model, that has a _has_one_ association to the Contact
  # model. It uses the _params_ hash to determine the contact field and the
  # contact value.
  #
  # It is expected that the params hash includes both fields
  #
  #    params[:contact][:field]    # Fieldname, such as :emails or :phones
  #    params[:contact][:contact]  # Value, such as 'hello@aol.com'
  #
  # It is ensured, the user is redirected to the specified url.
  def add_to(model, url)
    c = params[:contact]

    if c[:contact].blank?
      raise 'I am not going to save blank contacts!'
    end

    model.contact.field(c[:field]) << c[:contact].strip

    unless model.contact.save
      raise 'Could not save contact.'
    end

    flash[:notice] = t('messages.contact.success.save')
  rescue
    flash[:alert] = t('messages.contact.errors.save')
  ensure
    redirect_to url
  end

  # Removes a contact from a field. It behaves like
  # ContactsController#add_to(), but vice versa.
  def remove_from(model, url)
    c = params[:contact]

    unless model.contact.field(c[:field]).delete(c[:contact]) && model.contact.save
      raise 'Could not delete contact.'
    end

    flash[:notice] = t('messages.contact.success.delete')
  rescue
    flash[:alert] = t('messages.contact.errors.delete')
  ensure
    redirect_to url
  end
end

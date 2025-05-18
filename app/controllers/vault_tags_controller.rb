# frozen_string_literal: true
class VaultTagsController < ApplicationController
  before_action :find_context
  before_action :find_tag, only: %i[update destroy]
  before_action :load_tags, only: %i[index create update]

  def index; end

  def create
    @tag = @key.tags.build(tag_params)
    if @tag.save
      redirect_to project_key_vault_tags_path(@project, @key),
                  notice: 'Tag was successfully created.'
    else
      render :index
    end
  end

  def update
    if @project && @key
      if @tag.update(tag_params)
        redirect_to project_key_vault_tags_path(@project, @key),
                    notice: 'Tag was successfully updated.'
      else
        render :index
      end
    else
      if @tag.update(tag_params)
        redirect_to vault_settings_path, notice: 'Tag was successfully updated.'
      else
        redirect_to vault_settings_path, alert: 'Update failed.'
      end
    end
  end

  def destroy
    @tag.destroy
    redirect_to project_key_vault_tags_path(@project, @key),
                notice: 'Tag was successfully deleted.'
  end

  private

  def find_context
    if params[:project_id].present? && params[:key_id].present?
      @project = Project.find(params[:project_id])
      @key     = @project.keys.find(params[:key_id])
    end
  end

  def find_tag
    if @key
      @tag = @key.tags.find(params[:id])
    else
      require_admin
      @tag = Vault::Tag.find(params[:id])
    end
  end

  def load_tags
    @tags = @key.present? ? @key.tags : []
  end

  def tag_params
    params[:vault_tag] || params[:tag] or raise ActionController::ParameterMissing.new(:tag)
    (params[:vault_tag] || params[:tag]).permit(:name, :color)
  end
end

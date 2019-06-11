class TagsController < ApplicationController
  def index
    render_ok(Tag.all)
  end

  def show
    tag = Tag.find(params[:id])
    render_ok(tag)
  end

  def create
    tag = Tag.new(tag_params)
    if tag.save
      render_ok(tag)
    else
      render_ng(400, tag.errors)
    end
  end

  def update
    tag = Tag.find(params[:id])
    if tag.update(tag_params)
      render_ok(tag)
    else
      render_ng(400, tag.errors)
    end
  end

  def destroy
    tag = Tag.find(params[:id])
    if tag.destroy
      render_ok(tag)
    else
      render_ng(400, tag.errors)
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end

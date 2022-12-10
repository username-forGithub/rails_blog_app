class Api::V1::PostsController < Api::V1::ApplicationController
  before_action :set_post, only: [:show]
  before_action :set_author, only: %i[index show]
  before_action :authorize_request
  def index
    posts = @author.posts
    render json: posts, status: :ok
  end

  def show
    render json: @post, status: :ok
  end

  def list_posts
    author_id = params[:user_id]
    if author_id
      posts = Post.where(author_id:)
      render json: { status: 'SUCCESS', message: 'Loaded posts successfully', data: posts }, status: :ok
    else
      render json: { status: 'ERROR', message: 'User posts not found' }, status: :not_found
    end
  end

  def list_comments
    author_id = params[:user_id]
    post_id = params[:post_id]
    if author_id && post_id
      comments = Comment.where(author_id:, post_id:)
      render json: { status: 'SUCCESS', message: 'Loaded comments successfully', data: comments },
             status: :ok
    else
      render json: { status: 'ERROR', message: 'User or post not found' }, status: :not_found
    end
  end

  def add_comment
    author_id = @current_user.id
    text = params[:text]
    post_id = params[:post_id]
    if author_id && text && post_id
      comment = Comment.new(author_id:, text:, post_id:)
      if comment.save
        render json: { status: 'SUCCESS', message: 'Saved comment successfully', data: comment },
               status: :ok
      else
        render json: { status: 'ERROR', message: 'Comment not saved', data: comment.errors },
               status: :unprocessable_entity
      end
    else
      render json: { status: 'ERROR', message: 'Parameters incomplete' }, status: :not_found
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_author
    @author = User.find(params[:user_id])
  end

  def set_post
    @post = set_author.posts.find(params[:id])
  end
end

class ItemsController < ApplicationController
  require 'payjp'

  before_action :set_find,only:[:show, :destroy, :edit, :update]
  before_action :move_to_session, only: [:buycheck, :payment, :new]
  before_action :correct_user, only: [:edit]



  def index
    @items = Item.includes(:images, :category, :seller).order(created_at: :desc) 
    @parents = Category.all.order("id ASC").limit(13)
  end

  def category
    @categories = Category.where(ancestry: nil)
    respond_to do |format|
      format.json
    end
  end
  
  def new
    @item = Item.new
    @item.images.build
      @category_parent_array = Category.where(ancestry: nil).pluck(:name)
      @category_parent_array.unshift("選択してください")
  end
  
  def get_category_children
    #選択された親カテゴリーに紐付く子カテゴリーの配列を取得
    @category_children = Category.find_by(name: "#{params[:parent_name]}", ancestry: nil).children
  end

  def get_category_grandchildren
    #選択された子カテゴリーに紐付く孫カテゴリーの配列を取得
    @category_grandchildren = Category.find("#{params[:child_id]}").children
  end

  def create
      @item = Item.new(item_params)
      @category_parent_array = Category.where(ancestry: nil).pluck(:name)
      if @item.save
        redirect_to root_path
      else
        render :new
      end
  end

  
  def show
    @item = Item.find(params[:id]) 
  end

  def destroy
    @item = Item.find_by(id: params[:id])
    @item.destroy
    redirect_to root_path
  end

  def buycheck
    render 'items/buycheck'
  end

  def edit
    @item = Item.find(params[:id])
    # @image = Image.find(params[:id])
    @item.images
    @category_parent_array = Category.where(ancestry: nil).pluck(:name)

    grandchild_category = @item.category
    child_category = grandchild_category.parent

    @category_parent_array = []
    Category.where(ancestry: nil).each do |parent|
      @category_parent_array << parent.name
    end

    @category_children_array = []
    Category.where(ancestry: child_category.ancestry).each do |children|
    @category_children_array << children
    end

    @category_grandchildren_array = []
    Category.where(ancestry: grandchild_category.ancestry).each do |grandchildren|
    @category_grandchildren_array << grandchildren
    end
  end

  def update
    @item = Item.find(params[:id])
    @category_parent_array = Category.where(ancestry: nil).pluck(:name)
    # @user = User.find(params[:id])
    if @item.update(item_params)
      redirect_to root_path
    else
      redirect_to edit_item_path
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :price, :description, :condition, :delivery_charge, :delivery_day, :size, :prefecture_id, :category_id, :brand_id, images_attributes: [:image, :image_cache, :id ,:_destroy]).merge(seller_id: current_user.id, state: true)
    # .merge(seller_id: current_user.id)ユーザーデータできたら修正する, imageできたら追加する
  end

  def set_payment_card
    if params[:shipping_method] == "card2"
      card = Card.where(user_id: current_user.id).second
    else
      card = Card.where(user_id: current_user.id).first
    end
  end

  def set_find
    @item = Item.find(params[:id])
  end

  def move_to_session
    redirect_to new_user_session_path unless user_signed_in?
  end

  def correct_user
    @item = Item.find(params[:id])
    redirect_to root_path if current_user.id != @item.seller_id
  end
end

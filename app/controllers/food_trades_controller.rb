class FoodTradesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :find_food_trade, only: [:show, :destroy, :edit, :update]

  def user_food_trades
    @user = current_user
    @food_trades = @user.food_trades
  end

  def index
    @food_trades = FoodTrade.where(status: "Available")
  end

  def show
  end

  def new
    @food_trade = FoodTrade.new()
  end

  def create
    @food_trade = FoodTrade.new(food_trade_params)
    if @food_trade.save
      redirect_to :show
    else
      render :new
    end
  end

  def destroy
    if @food_trade.destroy
      redirect_to :index
    else
      render :show
    end
  end

  def edit
  end

  def update
    @food_trade.update(food_trade_params)
    if @food_trade.save
      redirect_to :show
    else
      render :edit
    end
  end

  private

  def find_food_trade
    @food_trade = FoodTrade.find(params[:id])
  end

  def food_trade_params
    params.require(:food_trade).permit(:amount, :unit, :description, :location)
  end
end

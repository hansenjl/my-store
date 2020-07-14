class PurchasesController < ApplicationController
    def new
        if params[:item_id] && item = Item.find_by_id(params[:item_id])
            @purchase = item.purchases.build
        else
            @purchase = Purchase.new
        end
    end

    def create
        @purchase = current_user.purchases.build(purchase_params)
        if valid_purchase?
            @purchase.save
            redirect_to purchase_path(@purchase)
        else
            render :new
        end
    end

    def show
        @purchase = Purchase.find_by_id(params[:id])
    end

    private

    def valid_purchase?
        if !@purchase.item_id || !Item.find_by_id(@purchase.item_id)
            @errors = "Must select an item"
        elsif !@purchase.quantity || @purchase.quantity < 1
            @errors = "Must select a quantity greater than 0"
        elsif @purchase.quantity > @purchase.item.quantity
            @errors = "Quantity selected is too large"
        elsif (@purchase.quantity * @purchase.item.price) > current_user.balance
            @errors = "Not enough money in your account to complete this transaction"
        end
        !@errors #this will result in the method returning true or false
    end

    def purchase_params
        params.require(:purchase).permit(:item_id, :quantity)
    end

end

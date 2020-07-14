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
        if !!@purchase.item_id && !!Item.find_by_id(@purchase.item_id) && !!@purchase.quantity && @purchase.quantity > 0 && (@purchase.quantity * @purchase.item.price) <= current_user.balance
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

    def purchase_params
        params.require(:purchase).permit(:item_id, :quantity)
    end

end

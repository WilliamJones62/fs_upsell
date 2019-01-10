class DontSellsController < ApplicationController
  before_action :set_dont_sell, only: [:show, :edit, :update, :destroy]

  # GET /dont_sells
  def index
    @dont_sells = DontSell.all
  end

  # GET /dont_sells/1
  def show
  end

  # GET /dont_sells/new
  def new
    @new_dontcall = true
    build_lists
    @dont_sell = DontSell.new
  end

  # GET /dont_sells/1/edit
  def edit
    @new_dontcall = false
    build_lists
  end

  # POST /dont_sells
  def create
    @dont_sell = DontSell.new(dont_sell_params)

    respond_to do |format|
      if @dont_sell.save
        format.html { redirect_to @dont_sell, notice: 'Dont sell was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /dont_sells/1
  def update
    respond_to do |format|
      if @dont_sell.update(dont_sell_params)
        format.html { redirect_to @dont_sell, notice: 'Dont sell was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /dont_sells/1
  def destroy
    @dont_sell.destroy
    respond_to do |format|
      format.html { redirect_to dont_sells_url, notice: 'Dont sell was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dont_sell
      @dont_sell = DontSell.find(params[:id])
    end

    # Build lists of current customers and parts
    def build_lists
      if !$alldesc
        # first time in. Need to set up list variables
        $alldesc = []
        tempcust = []
        $allcust = []
        $allcustA = []
        $allpart = []
        authorlist = AuthorList.all
        authorlist.each do |a|
          desc = a.part_desc.gsub(' ', '~')
          $alldesc.push(desc)
          $allpart.push(a.partcode)
          $allcustA.push(a.custcode)
        end

        calllist = CallList.all
        calllist.each do |c|
          if !tempcust.include?(c.custcode)
            tempcust.push(c.custcode)
          end
          $allcust.push(c.custcode)
        end
        $customer = tempcust.sort
      end

      if @new_dontcall
        custA = $customer[0]
      else
        custA = @dont_sell.customer
      end

      temppart = []
      i = 0
      len = $allcustA.length
      while i < len
        if $allcustA[i] == custA && !temppart.include?($allpart[i])
          temppart.push($allpart[i])
        end
        i += 1
      end
      @customer = $customer
      @part = temppart.sort
      if @new_dontcall
        partmstr = Partmstr.find_by(part_code: @part[0])
      else
        partmstr = Partmstr.find_by(part_code: @dont_sell.part)
      end
      if partmstr
        @desc = partmstr.part_desc
      else
        @desc = 'NO DESCRIPTION AVAILABLE'
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dont_sell_params
      params.require(:dont_sell).permit(:customer, :part, :dontcalls_start, :dontcalls_end)
    end
end

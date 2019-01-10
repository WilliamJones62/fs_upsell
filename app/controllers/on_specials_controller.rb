class OnSpecialsController < ApplicationController
  before_action :set_on_special, only: [:show, :edit, :update, :destroy]

  # GET /on_specials
  def index
    @on_specials = OnSpecial.all
  end

  # GET /on_specials/1
  def show
  end

  # GET /on_specials/new
  def new
    @new_onspecial = true
    build_lists
    @on_special = OnSpecial.new
  end

  # GET /on_specials/1/edit
  def edit
    @new_onspecial = false
    build_lists
  end

  # POST /on_specials
  def create
    custcode = params[:on_special][:custcode]
    if custcode[1] == 'ALL'
      $customer.each do |c|
        if c != 'ALL'
          op = on_special_params
          op[:customer] = c
          @onspecial = OnSpecial.new(op)
          @onspecial.save
        end
      end
      redirect_to action: "index", notice: 'Onspecials were successfully created.'
    elsif custcode.length > 1
      custcode.each do |c|
        if !c.blank? && c != 'ALL'
          op = on_special_params
          op[:customer] = c
          @onspecial = OnSpecial.new(op)
          @onspecial.save
        end
      end
      redirect_to action: "index", notice: 'Onspecials were successfully created.'
    else
      op = on_special_params
      op[:customer] = custcode[1]
      @on_special = OnSpecial.new(on_special_params)

      respond_to do |format|
        if @on_special.save
          format.html { redirect_to @on_special, notice: 'On special was successfully created.' }
        else
          format.html { render :new }
        end
      end
    end
  end

  # PATCH/PUT /on_specials/1
  def update
    respond_to do |format|
      if @on_special.update(on_special_params)
        format.html { redirect_to @on_special, notice: 'On special was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /on_specials/1
  def destroy
    @on_special.destroy
    respond_to do |format|
      format.html { redirect_to on_specials_url, notice: 'On special was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_on_special
      @on_special = OnSpecial.find(params[:id])
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
        $customer_new = tempcust.sort
        $customer_new.unshift("ALL")
      end

      if @new_onspecial
        custA = 'ALL'
      else
        custA = @on_special.customer
      end

      temppart = []
      i = 0
      len = $allcustA.length
      while i < len
        if ($allcustA[i] == custA || custA == 'ALL') && !temppart.include?($allpart[i])
          temppart.push($allpart[i])
        end
        i += 1
      end
      @part = temppart.sort
      if @new_onspecial
        partmstr = Partmstr.find_by(part_code: @part[0])
      else
        partmstr = Partmstr.find_by(part_code: @on_special.part)
      end
      if partmstr
        @desc = partmstr.part_desc
      else
        @desc = 'NO DESCRIPTION AVAILABLE'
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def on_special_params
      params.require(:on_special).permit(:customer, :custcode, :part, :onspecials_start, :onspecials_end)
    end
end

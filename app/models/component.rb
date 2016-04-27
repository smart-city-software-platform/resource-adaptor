class Component < ActiveRecord::Base
  belongs_to :basic_resource

  def temperature
    rand = Random.new
    rand.rand(0..40)
  end

  def manipulate_led(on = true)
    # code to send signal to led
    # return OK if ok
    # return ERROR if !ok
  end

  def gps
    random = Random.new
    [random.rand, random.rand]
  end
end

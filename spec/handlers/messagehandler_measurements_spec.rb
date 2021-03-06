require 'spec_helper'
require './lib/status.rb'
#require './lib/messaging/messenger.rb'
require './lib/handlers/messagehandler.rb'
require './spec/fixtures/stub_messenger.rb'
require './lib/handlers/messagehandler_measurements.rb'

describe MessageHandlerMeasurement do
  let(:message) { MessageHandlerMessage.new({}, StubMessenger.new) }

  before do
    DbAccess.current = DbAccess.new('development')
    DbAccess.current = DbAccess.current
    DbAccess.current.disable_log_to_screen()

    Status.current = Status.new

    messaging = StubMessenger.new
    messaging.reset

    @handler = MessageHandlerMeasurement.new(messaging)
    @main_handler = MessageHandler.new(messaging)
  end

  ## measurements

  it "white list" do
    list = MessageHandlerMeasurement::WHITELIST
    expect(list.count).to eq(2)
  end

  it "read measurements" do

    # write a measurement
    measurement_value = rand(9999999).to_i
    measurement_text  = rand(9999999).to_s
    DbAccess.current.write_measurements(measurement_value, measurement_text)

    message.handled = false
    message.handler = @main_handler

    # read the list of measurements
    @handler.read_measurements(message)

    # check if the created item is into the list to send
    found_in_list = false
    @handler.messaging.message[:measurements].each do |item|
      if item['value'] == measurement_value and item['ext_info'] == measurement_text
        found_in_list = true
      end
    end

    expect(found_in_list).to eq(true)
    expect(@handler.messaging.message[:message_type]).to eq('read_measurements_response')
  end

  it "delete measurement" do

    # write two measurements
    measurement_value_1 = rand(9999999).to_i
    measurement_text_1  = rand(9999999).to_s
    DbAccess.current.write_measurements(measurement_value_1, measurement_text_1)

    measurement_value_2 = rand(9999999).to_i
    measurement_text_2  = rand(9999999).to_s
    DbAccess.current.write_measurements(measurement_value_2, measurement_text_2)

    # check if the measurements are in the database and get the id
    found_in_list_1       = false
    found_in_list_2       = false
    found_in_list_1_after = false
    found_in_list_2_after = false
    id_1                  = 0
    id_2                  = 0
    return_list = DbAccess.current.read_measurement_list()

    return_list.each do |item|
      if item['value'] == measurement_value_1 and item['ext_info'] == measurement_text_1
        found_in_list_1 = true
        id_1 = item['id']
      end
      if item['value'] == measurement_value_2 and item['ext_info'] == measurement_text_2
        found_in_list_2 = true
        id_2 = item['id']
      end
    end

    # try to delete the measurements
    message.handled = false
    message.handler = @main_handler
    message.payload = {'ids' => [id_1,id_2]}

    @handler.delete_measurements(message)


    # check if the measurements are still in the database and get the id
    found_in_list_1_after = false
    found_in_list_2_after = false
    return_list = DbAccess.current.read_measurement_list()

    return_list.each do |item|
      if item['value'] == measurement_value_1 and item['ext_info'] == measurement_text_1
        found_in_list_1_after = true
      end
      if item['value'] == measurement_value_2 and item['ext_info'] == measurement_text_2
        found_in_list_2_after = true
      end
    end


    expect(found_in_list_1).to eq(true)
    expect(found_in_list_2).to eq(true)
    expect(found_in_list_1_after).to eq(false)
    expect(found_in_list_2_after).to eq(false)
    expect(@handler.messaging.message[:message_type]).to eq('confirmation')

  end

end

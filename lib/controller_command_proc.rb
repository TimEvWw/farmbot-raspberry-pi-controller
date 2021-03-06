# FarmBot Controller command processor
# processes the comamdn and calles the right function in the hardware class

class ControllerCommandProc

  def initialize
<<<<<<< HEAD
    #@bot_dbaccess        = $bot_dbaccess
=======
    @bot_dbaccess = DbAccess.current
>>>>>>> 4a9773c7ca757a97b363fb2d6f7fb8845c99c40b
  end

  WHITELIST = ['move_absolute','move_relative','home_x','home_y','home_z',
               'calibrate_x','calibrate_y','calibrate_z','dose_water',
               'set_speed','pin_write','pin_read','pin_mode','pin_pulse',
               'servo_move']

  def check_whitelist(function)
    unless WHITELIST.include?(function.downcase)
      raise "UNAUTHORIZED: #{function}"
    end
  end

  def start_command( cmd )

<<<<<<< HEAD
    send_command(command_line)
=======
    if cmd != nil
      cmd.command_lines.each do |command_line|
        send_command(command_line)
      end
    else
      sleep 0.1
    end

    Status.current.info_movement = 'idle'
>>>>>>> 4a9773c7ca757a97b363fb2d6f7fb8845c99c40b

  end

  def send_command(command_line)
    function = command_line.action.downcase.sub(' ','_')
    check_whitelist(function)

    if $hardware_sim == 0
      send(function, command_line)
    else
<<<<<<< HEAD
      #$status.info_movement = 
      @info_movement = "#{command_line.action.downcase} xyz=#{command_line.coord_x} #{command_line.coord_y} #{command_line.coord_z} amt=#{command_line.amount} spd=#{command_line.speed} pin=#{command_line.pin_nr}"
      puts "simulating: #{@info_movement}"
      #@bot_dbaccess.write_to_log(1,@info_movement)
      #@bot_dbaccess.write_to_log(1,"simulating hardware: #{function}")
      #sleep 0.1
=======
      sleep 0.1
>>>>>>> 4a9773c7ca757a97b363fb2d6f7fb8845c99c40b
    end
  end

  def move_absolute(command_line)
    HardwareInterface.current.move_absolute(command_line.coord_x, command_line.coord_y, command_line.coord_z)
  end

  def move_relative(command_line)
    HardwareInterface.current.move_relative(command_line.coord_x, command_line.coord_y, command_line.coord_z)
  end

  def home_x(command_line)
    HardwareInterface.current.move_home_x
  end

  def home_y(command_line)
    HardwareInterface.current.move_home_y
  end

  def home_z(command_line)
    HardwareInterface.current.move_home_z
  end

  def calibration_x(command_line)
    HardwareInterface.current.calibrate_x
  end

  def calibration_y(command_line)
    HardwareInterface.current.calibrate_y
  end

  def calibration_z(command_line)
    HardwareInterface.current.calibrate_z
  end

  def dose_water(command_line)
    HardwareInterface.current.dose_water(command_line.amount)
  end

#  def set_speed(command_line)
#    HardwareInterface.current.set_speed(command_line.speed)
#  end

  def pin_write(command_line)
    HardwareInterface.current.pin_std_set_value(command_line.pin_nr, command_line.pin_value_1, command_line.pin_mode)
  end

  def pin_read(command_line)
    HardwareInterface.current.pin_std_read_value(command_line.pin_nr, command_line.pin_mode, command_line.external_info)
  end

  def pin_mode(command_line)
    HardwareInterface.current.pin_std_set_mode(command_line.pin_nr, command_line.pin_mode)
  end

  def pin_pulse(command_line)
    HardwareInterface.current.pin_std_pulse(command_line.pin_nr, command_line.pin_value_1,
                command_line.pin_value_2, command_line.pin_time, command_line.pin_mode)
  end

  def servo_move(command_line)
    HardwareInterface.current.servo_std_move(command_line.pin_nr, command_line.pin_value_1)
  end



end

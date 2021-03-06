class Catos < Oxidized::Model

  prompt /^[\w.@-]+> \(enable\) $/
  comment '# '

  cmd :all do |cfg|
    cfg.each_line.to_a[1..-2].join
  end

  cmd 'show system' do |cfg|
    cfg = cfg.gsub /(\s+)\d+,\d+:\d+:\d+(\s+)/, '\1X\2'
    comment cfg
  end

  cmd 'show version' do |cfg|
    cfg = cfg.gsub /\d+(K)/, 'X\1'
    cfg = cfg.gsub /^(Uptime is ).*/, '\1X'
    comment cfg
  end

  cmd 'show conf all' do |cfg|
    cfg = cfg.sub /^(#time: ).*/, '\1X'
    cfg.each_line.drop_while { |line| not line.match /^begin/ }.join
  end

  cfg :telnet do
    username /^Username: /
    password /^Password:/
  end

  cfg :ssh, :telnet do
    post_login 'set length 0'
    pre_logout 'exit'
  end

end

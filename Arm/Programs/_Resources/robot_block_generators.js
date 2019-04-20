'use strict';

Blockly.JavaScript['enable_pump_inline'] = function(block) {
    var value_enable = (block.getFieldValue('enable') == "TRUE")
    var code = 'RobotCommands.enablePump(' + value_enable + ');\n';
    return code;
};

Blockly.JavaScript['enable_pump'] = function(block) {
    var value_enable = Blockly.JavaScript.valueToCode(block, 'enable', Blockly.JavaScript.ORDER_ATOMIC);
    var code = 'RobotCommands.enablePump(' + value_enable + ');\n';
    return code;
};

Blockly.JavaScript['pause_inline'] = function(block) {
    var value_seconds = block.getFieldValue('seconds');
    var code = 'RobotCommands.pause(' + value_seconds + ');\n';
    return code;
};

Blockly.JavaScript['pause'] = function(block) {
    var value_seconds = Blockly.JavaScript.valueToCode(block, 'seconds', Blockly.JavaScript.ORDER_ATOMIC);
    var code = 'RobotCommands.pause(' + value_seconds + ');\n';
    return code;
};

Blockly.JavaScript['move_inline'] = function(block) {
    var value_x = block.getFieldValue('x');
    var value_y = block.getFieldValue('y');
    var value_z = block.getFieldValue('z');
    var value_t = block.getFieldValue('t')
    var code = 'RobotCommands.move(' + value_x + ', ' + value_y + ', ' + value_z + ', ' + value_t + ');\n';
    return code;
};

Blockly.JavaScript['move'] = function(block) {
    var value_x = Blockly.JavaScript.valueToCode(block, 'x', Blockly.JavaScript.ORDER_ATOMIC);
    var value_y = Blockly.JavaScript.valueToCode(block, 'y', Blockly.JavaScript.ORDER_ATOMIC);
    var value_z = Blockly.JavaScript.valueToCode(block, 'z', Blockly.JavaScript.ORDER_ATOMIC);
    var value_t = Blockly.JavaScript.valueToCode(block, 't', Blockly.JavaScript.ORDER_ATOMIC);
    var code = 'RobotCommands.move(' + value_x + ', ' + value_y + ', ' + value_z + ', ' + value_t + ');\n';
    return code;
};

Blockly.JavaScript['is_place_free_inline'] = function(block) {
    var value_x = Blockly.JavaScript.valueToCode(block, 'x', Blockly.JavaScript.ORDER_ATOMIC);
    var value_z = Blockly.JavaScript.valueToCode(block, 'z', Blockly.JavaScript.ORDER_ATOMIC);
//    var code = 'RobotCommands.isPlaceFree(' + value_x + ', ' + value_z + ');\n';
    var code = 'RobotCommands.enablePump(true);\n';
    return code
};


Blockly.JavaScript['is_place_free'] = function(block) {
    var value_x = Blockly.JavaScript.valueToCode(block, 'x', Blockly.JavaScript.ORDER_ATOMIC);
    var value_z = Blockly.JavaScript.valueToCode(block, 'z', Blockly.JavaScript.ORDER_ATOMIC);
//    var code = 'RobotCommands.isPlaceFree(' + value_x + ', ' + value_z + ');\n';
    var code = 'RobotCommands.enablePump(true);\n';
    return code
};

// Generators for blocks defined in `sound_blocks.json`.
Blockly.JavaScript['play_sound'] = function(block) {
    var value = '\'' + block.getFieldValue('VALUE') + '\'';
    return 'MusicMaker.playSound(' + value + ');\n';
};

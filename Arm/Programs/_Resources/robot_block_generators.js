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
    var value_seconds = block.getFieldValue('seconds').replace(",", ".");
    var code = 'RobotCommands.pause(' + value_seconds + ');\n';
    return code;
};

Blockly.JavaScript['pause'] = function(block) {
    var value_seconds = Blockly.JavaScript.valueToCode(block, 'seconds', Blockly.JavaScript.ORDER_ATOMIC);
    var code = 'RobotCommands.pause(' + value_seconds + ');\n';
    return code;
};

Blockly.JavaScript['move_inline'] = function(block) {
    var value_x = block.getFieldValue('x').replace(",", ".");
    var value_y = block.getFieldValue('y').replace(",", ".");
    var value_z = block.getFieldValue('z').replace(",", ".");
    var value_t = block.getFieldValue('t').replace(",", ".");
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

Blockly.JavaScript['angle_inline'] = function(block) {
    var value_alpha = block.getFieldValue('alpha').replace(",", ".");
    var value_t = block.getFieldValue('t').replace(",", ".");
    var code = 'RobotCommands.setAngle(' + value_alpha + ', ' + value_t + ');\n';
    return code;
};

Blockly.JavaScript['angle'] = function(block) {
    var value_alpha = Blockly.JavaScript.valueToCode(block, 'alpha', Blockly.JavaScript.ORDER_ATOMIC);
    var value_t = Blockly.JavaScript.valueToCode(block, 't', Blockly.JavaScript.ORDER_ATOMIC);
    var code = 'RobotCommands.setAngle(' + value_alpha + ', ' + value_t + ');\n';
    return code;
};

Blockly.JavaScript['circular_inline'] = function(block) {
    var value_radius = block.getFieldValue('radius').replace(",", ".");
    var value_t = block.getFieldValue('t').replace(",", ".");
    var code = 'RobotCommands.circularMovement(' + value_radius + ', ' + value_t + ');\n';
    return code;
};

Blockly.JavaScript['circular'] = function(block) {
    var value_radius = Blockly.JavaScript.valueToCode(block, 'radius', Blockly.JavaScript.ORDER_ATOMIC);
    var value_t = Blockly.JavaScript.valueToCode(block, 't', Blockly.JavaScript.ORDER_ATOMIC);
    var code = 'RobotCommands.circularMovement(' + value_radius + ', ' + value_t + ');\n';
    return code;
};

Blockly.JavaScript['is_place_free_inline'] = function(block) {
    var value_x = block.getFieldValue('x').replace(",", ".");
    var value_z = block.getFieldValue('z').replace(",", ".");
    var code = 'RobotCommands.isPlaceFree(' + value_x + ', ' + value_z + ')';
    return [code, Blockly.JavaScript.ORDER_FUNCTION_CALL];
};

Blockly.JavaScript['is_place_free'] = function(block) {
    var value_x = Blockly.JavaScript.valueToCode(block, 'x', Blockly.JavaScript.ORDER_ATOMIC);
    var value_z = Blockly.JavaScript.valueToCode(block, 'z', Blockly.JavaScript.ORDER_ATOMIC);
    var code = 'RobotCommands.isPlaceFree(' + value_x + ', ' + value_z + ')';
    return [code, Blockly.JavaScript.ORDER_FUNCTION_CALL];
};

Blockly.JavaScript['get_x_axis_of_cube_n_inline'] = function(block) {
    var value_n = block.getFieldValue('n')
    var code = 'RobotCommands.getXAxisOfCube(' + value_n + ')';
    return [code, Blockly.JavaScript.ORDER_FUNCTION_CALL];
};

Blockly.JavaScript['get_x_axis_of_cube_n'] = function(block) {
    var value_n = Blockly.JavaScript.valueToCode(block, 'n', Blockly.JavaScript.ORDER_ATOMIC);
    var code = 'RobotCommands.getXAxisOfCube(' + value_n + ')';
    return [code, Blockly.JavaScript.ORDER_FUNCTION_CALL];
};

Blockly.JavaScript['get_z_axis_of_cube_n_inline'] = function(block) {
    var value_n = block.getFieldValue('n')
    var code = 'RobotCommands.getZAxisOfCube(' + value_n + ')';
    return [code, Blockly.JavaScript.ORDER_FUNCTION_CALL];
};

Blockly.JavaScript['get_z_axis_of_cube_n'] = function(block) {
    var value_n = Blockly.JavaScript.valueToCode(block, 'n', Blockly.JavaScript.ORDER_ATOMIC);
    var code = 'RobotCommands.getZAxisOfCube(' + value_n + ')';
    return [code, Blockly.JavaScript.ORDER_FUNCTION_CALL];
};

Blockly.JavaScript['reset_cube_inline'] = function(block) {
    var value_cube = block.getFieldValue('cube').replace(",", ".");
    var code = 'RobotCommands.resetCubePosition(' + value_cube + ');\n';
    return code;
};

Blockly.JavaScript['reset_cube'] = function(block) {
    var value_cube = Blockly.JavaScript.valueToCode(block, 'cube', Blockly.JavaScript.ORDER_ATOMIC);
    var code = 'RobotCommands.resetCubePosition(' + value_cube + ');\n';
    return code;
};

// Generators for blocks defined in `sound_blocks.json`.
Blockly.JavaScript['play_sound'] = function(block) {
    var value = '\'' + block.getFieldValue('VALUE') + '\'';
    return 'MusicMaker.playSound(' + value + ');\n';
};

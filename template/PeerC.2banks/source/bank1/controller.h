// ***************************************************************************
// controller
// ***************************************************************************

#pragma once

#include <vectrex.h>



// ---------------------------------------------------------------------------
// controller initialization, each controller axis can be individually
// switched on or off; for performance reasons, activate only what you
// really need

static inline void enable_controller_1_x()
{
		Vec_Joy_Mux_1_X = 1;
}

static inline void enable_controller_1_y()
{
		Vec_Joy_Mux_1_Y = 3;
}

static inline void enable_controller_2_x()
{
		Vec_Joy_Mux_2_X = 5;
}

static inline void enable_controller_2_y()
{
		Vec_Joy_Mux_2_Y = 7;
}

static inline void disable_controller_1_x()
{
		Vec_Joy_Mux_1_X = 0;
}

static inline void disable_controller_1_y()
{
		Vec_Joy_Mux_1_Y = 0;
}

static inline void disable_controller_2_x()
{
		Vec_Joy_Mux_2_X = 0;
}

static inline void disable_controller_2_y()
{
		Vec_Joy_Mux_2_Y = 0;
}

// ---------------------------------------------------------------------------
// read controller buttons

// must be called once each time you want to check the buttons
static inline void check_buttons()
{
	Read_Btns();
}

static inline unsigned int buttons_pressed()
{
	return Vec_Buttons;
}

static inline unsigned int buttons_held()
{
	return Vec_Btn_State;
}

// call these functions below to check if a specific button is pressed,
// the button must be released before another press is registered,
// return value is 0 or 1, so these functions can be used as check in
// conditional statements

static inline unsigned int button_1_1_pressed()
{
	return (buttons_pressed() & 0b00000001);
}

static inline unsigned int button_1_2_pressed()
{
	return (buttons_pressed() & 0b00000010);
}
static inline unsigned int button_1_3_pressed()
{
	return (buttons_pressed() & 0b00000100);
}
static inline unsigned int button_1_4_pressed()
{
	return (buttons_pressed() & 0b00001000);
}

static inline unsigned int button_2_1_pressed()
{
	return (buttons_pressed() & 0b00010000);
}

static inline unsigned int button_2_2_pressed()
{
	return (buttons_pressed() & 0b00100000);
}
static inline unsigned int button_2_3_pressed()
{
	return (buttons_pressed() & 0b01000000);
}

static inline unsigned int button_2_4_pressed()
{
	return (buttons_pressed() & 0b10000000);
}

// call these functions below to check if a specific button is held,
// return value is 0 or 1, so these functions can be used as check in
// conditional statements

static inline unsigned int button_1_1_held()
{
	return (buttons_held() & 0b00000001);
}

static inline unsigned int button_1_2_held()
{
	return (buttons_held() & 0b00000010);
}
static inline unsigned int button_1_3_held()
{
	return (buttons_held() & 0b00000100);
}
static inline unsigned int button_1_4_held()
{
	return (buttons_held() & 0b00001000);
}

static inline unsigned int button_2_1_held()
{
	return (buttons_held() & 0b00010000);
}

static inline unsigned int button_2_2_held()
{
	return (buttons_held() & 0b00100000);
}
static inline unsigned int button_2_3_held()
{
	return (buttons_held() & 0b01000000);
}

static inline unsigned int button_2_4_held()
{
	return (buttons_held() & 0b10000000);
}

// ---------------------------------------------------------------------------
// read controller joysticks

// must be called once each time you want to check the joysticks
static inline void check_joysticks()
{
	Joy_Digital();
}

static inline int joystick_1_x()
{
	return Vec_Joy_1_X;
}

static inline int joystick_1_y()
{
	return Vec_Joy_1_Y;
}

static inline int joystick_2_x()
{
	return Vec_Joy_2_X;
}

static inline int joystick_2_y()
{
	return Vec_Joy_2_Y;
}

// call these functions below to check if a joystick is moved in
// a specific direction,
// return value is 0 or 1, so these functions can be used as check in
// conditional statements

static inline int joystick_1_left()
{
	return (joystick_1_x() < 0);
}

static inline int joystick_1_right()
{
	return (joystick_1_x() > 0);
}

static inline int joystick_1_down()
{
	return (joystick_1_y() < 0);
}

static inline int joystick_1_up()
{
	return (joystick_1_y() > 0);
}

static inline int joystick_2_left()
{
	return (joystick_2_x() < 0);
}

static inline int joystick_2_right()
{
	return (joystick_2_x() > 0);
}

static inline int joystick_2_down()
{
	return (joystick_2_y() < 0);
}

static inline int joystick_2_up()
{
	return (joystick_2_y() > 0);
}

// ***************************************************************************
// end of file
// ***************************************************************************

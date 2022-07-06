*&---------------------------------------------------------------------*
*& Report Z_RESISTOR_COLOR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_RESISTOR_COLOR.

CLASS zcl_resistor_color DEFINITION.
  PUBLIC SECTION.
    METHODS resistor_color
      IMPORTING
        color_code   TYPE string
      RETURNING
        VALUE(value) TYPE i.
ENDCLASS.

CLASS zcl_resistor_color IMPLEMENTATION.

  METHOD resistor_color.

    CASE color_code.
      WHEN 'black'.
        value = 0.
      WHEN 'brown'.
        value = 1.
      WHEN 'red'.
        value = 2.
      WHEN 'orange'.
        value = 3.
      WHEN 'yellow'.
        value = 4.
      WHEN 'green'.
        value = 5.
      WHEN 'blue'.
        value = 6.
      WHEN 'violet'.
        value = 7.
      WHEN 'grey'.
        value = 8.
      WHEN 'white'.
        value = 9.
      WHEN OTHERS.
        value = -1.
    ENDCASE.

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_test DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    DATA cut TYPE REF TO zcl_resistor_color.
    METHODS setup.
    METHODS test_black FOR TESTING.
    METHODS test_white FOR TESTING.
    METHODS test_orange FOR TESTING.

ENDCLASS.


CLASS ltcl_test IMPLEMENTATION.

  METHOD setup.
    cut = NEW #( ).
  ENDMETHOD.

  METHOD test_black.
    cl_abap_unit_assert=>assert_equals(
      act = cut->resistor_color( 'black' )
      exp = 0 ).
  ENDMETHOD.

  METHOD test_white.
    cl_abap_unit_assert=>assert_equals(
      act = cut->resistor_color( 'white' )
      exp = 9 ).
  ENDMETHOD.

  METHOD test_orange.
    cl_abap_unit_assert=>assert_equals(
      act = cut->resistor_color( 'orange' )
      exp = 3 ).
  ENDMETHOD.

ENDCLASS.

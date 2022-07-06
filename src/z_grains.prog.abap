*&---------------------------------------------------------------------*
*& Report Z_GRAINS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_grains.

CLASS zcl_grains DEFINITION.

  PUBLIC SECTION.
    TYPES type_result TYPE p LENGTH 16 DECIMALS 0.
    METHODS square
      IMPORTING
        input         TYPE i
      RETURNING
        VALUE(result) TYPE type_result
      RAISING
        cx_parameter_invalid.
    METHODS total
      RETURNING
        VALUE(result) TYPE type_result
      RAISING
        cx_parameter_invalid.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.


CLASS zcl_grains IMPLEMENTATION.
  METHOD square.
    IF input < 1 OR input > 64.
      RAISE EXCEPTION NEW cx_parameter_invalid( ).
    ENDIF.
    result = 2 ** ( input - 1 ).
  ENDMETHOD.

  METHOD total.
    DATA lv_idx TYPE i VALUE 64.
    WHILE lv_idx > 0.
      result = result + ( 2 ** ( lv_idx - 1 ) ).
      lv_idx = lv_idx - 1.
    ENDWHILE.
  ENDMETHOD.
ENDCLASS.


CLASS ltcl_grains DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    DATA cut TYPE REF TO zcl_grains.
    METHODS setup.
    METHODS test_square_1 FOR TESTING RAISING cx_static_check.
    METHODS test_square_2 FOR TESTING RAISING cx_static_check.
    METHODS test_square_3 FOR TESTING RAISING cx_static_check.
    METHODS test_square_4 FOR TESTING RAISING cx_static_check.
    METHODS test_square_16 FOR TESTING RAISING cx_static_check.
    METHODS test_square_32 FOR TESTING RAISING cx_static_check.
    METHODS test_square_64 FOR TESTING RAISING cx_static_check.
    METHODS test_square_0 FOR TESTING RAISING cx_static_check.
    METHODS test_square_minus_1 FOR TESTING RAISING cx_static_check.
    METHODS test_square_65 FOR TESTING RAISING cx_static_check.
    METHODS test_total FOR TESTING RAISING cx_static_check.



ENDCLASS.

CLASS ltcl_grains IMPLEMENTATION.

  METHOD setup.
    cut = NEW zcl_grains( ).
  ENDMETHOD.

  "grains on square 1
  METHOD test_square_1.
    cl_abap_unit_assert=>assert_equals(
      act = cut->square( 1 )
      exp = 1 ).
  ENDMETHOD.

  "grains on square 2
  METHOD test_square_2.
    cl_abap_unit_assert=>assert_equals(
      act = cut->square( 2 )
      exp = 2 ).
  ENDMETHOD.

  "grains on square 3
  METHOD test_square_3.
    cl_abap_unit_assert=>assert_equals(
      act = cut->square( 3 )
      exp = 4 ).
  ENDMETHOD.

  "grains on square 4
  METHOD test_square_4.
    cl_abap_unit_assert=>assert_equals(
      act = cut->square( 4 )
      exp = 8 ).
  ENDMETHOD.

  "grains on square 16
  METHOD test_square_16.
    cl_abap_unit_assert=>assert_equals(
      act = cut->square( 16 )
      exp = 32768 ).
  ENDMETHOD.

  "grains on square 32
  METHOD test_square_32.
    cl_abap_unit_assert=>assert_equals(
      act = cut->square( 32 )
      exp = 2147483648 ).
  ENDMETHOD.

  "grains on square 64
  METHOD test_square_64.
    cl_abap_unit_assert=>assert_equals(
      act = cut->square( 64 )
      exp = 9223372036854775808 ).
  ENDMETHOD.

  "square 0 raises an exception
  METHOD test_square_0.
    TRY.
        cut->square( 0 ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_parameter_invalid.
    ENDTRY.
  ENDMETHOD.

  "negative square raises an exception
  METHOD test_square_minus_1.
    TRY.
        cut->square( -1 ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_parameter_invalid.
    ENDTRY.
  ENDMETHOD.

  "square greater than 64 raises an exception
  METHOD test_square_65.
    TRY.
        cut->square( 65 ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_parameter_invalid.
    ENDTRY.
  ENDMETHOD.

  "returns the total number of grains on the board
  METHOD test_total.
    cl_abap_unit_assert=>assert_equals(
      act = cut->total( )
      exp = 18446744073709551615 ).
  ENDMETHOD.


ENDCLASS.

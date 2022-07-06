*&---------------------------------------------------------------------*
*& Report z_hello_world
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_hello_world.

CLASS zcl_hello_world DEFINITION.
    PUBLIC SECTION.
        METHODS hello RETURNING VALUE(result) TYPE string.
ENDCLASS.

CLASS zcl_hello_world IMPLEMENTATION.

    METHOD hello.
        result = 'Hello, World!'.
    ENDMETHOD.

ENDCLASS.

CLASS ltcl_hello_world DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
    PRIVATE SECTION.
        METHODS test FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_hello_world IMPLEMENTATION.

    METHOD test.
        cl_abap_unit_assert=>assert_equals(
            act = NEW zcl_hello_world( )->hello( )
            exp = 'Hello, World!' ).
    ENDMETHOD.

ENDCLASS.

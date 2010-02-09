// -*- mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-

%feature("docstring",
         "Standard weight class, using floating-point values in the tropical semiring.") Weight;
struct Weight {
    %feature("docstring", "Get the floating-point value of a weight.");
    float Value();
    %feature("docstring",
             "Returns the zero weight for this semiring.  This is the weight which\n"
             "acts as an annihilator for multiplication and an identity for addition.\n"
             "For the standard weight class, its value is positive infinity.");
    static Weight const Zero();
    %feature("docstring",
             "Returns the one value for this semiring.  This is the weight which\n"
             "acts as an identity for multiplication.\n"
             "For the standard weight class, its value is zero.");
    static Weight const One();
};

%feature("docstring",
         "Standard weight class, using floating-point values in the log semiring.") LogWeight;
class LogWeight {
public:
    %feature("docstring", "Get the floating-point value of a weight.");
    float Value();
    %feature("docstring",
             "Returns the zero weight for this semiring.  This is the weight which\n"
             "acts as an annihilator for multiplication and an identity for addition.\n"
             "For the standard weight class, its value is positive infinity.");
    static LogWeight const Zero();
    %feature("docstring",
             "Returns the one value for this semiring.  This is the weight which\n"
             "acts as an identity for multiplication.\n"
             "For the standard weight class, its value is zero.");
    static LogWeight const One();
};

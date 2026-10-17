import "@typespec/http";

using TypeSpec.Http;

@service(#{ title: "Flight Booking API" })
namespace FlightBookingApi;

model City {
  code: string;
  name: string;
  country?: string;
}

model Money {
  amount: integer;
  currency: string;
}

model Airline {
  code: string;
  name: string;
}

model Flight {
  id: string;
  flightNumber: string;
  airline: Airline;
  origin: City;
  destination: City;
  departureAt: utcDateTime;
  arrivalAt: utcDateTime;
  durationMinutes: integer;
  price: Money;
  seatsAvailable: integer;
}

model Passenger {
  firstName: string;
  lastName: string;
  dateOfBirth: string;
  documentNumber: string;
}

model Contact {
  email: string;
  phone: string;
}

model Booking {
  code: string;
  status: string;
  flight: Flight;
  passengers: Passenger[];
  contact: Contact;
  totalPrice: Money;
  createdAt: utcDateTime;
}

model HealthResponse {
  status: "ok";
}

@route("/api/health")
interface Health {
  @get check(): HealthResponse;
}

@route("/api/cities")
interface Cities {
  @get list(): City[];
}

@route("/api/flights")
interface Flights {
  @get
  list(
    @query origin: string,
    @query destination: string,
    @query date: plainDate,
    @query passengers?: int32 = 1,
  ): Flight[] | BadRequestResponse;

  @get
  @route("/{id}")
  get(@path id: int32): Flight | NotFoundResponse;
}

model CreateBookingRequest {
  flightId: int32;
  contact: Contact;

  @minItems(1)
  passengers: Passenger[];
}

model BookingCreatedResponse {
  @statusCode
  statusCode: 201;

  @body
  booking: Booking;
}

model BookingCancelResponse {
  @statusCode
  statusCode: 200;

  @body
  booking: Booking;
}

@route("/api/bookings")
interface Bookings {
  @post
  create(@body request: CreateBookingRequest): BookingCreatedResponse | BadRequestResponse;

  @get
  @route("/{code}")
  get(
    @path code: string,
    @query lastName: string,
  ): Flight | NotFoundResponse;

  @post
  @route("/{code}/cancel")
  cancel(
    @path code: string,
    @query lastName: string
  ): BookingCancelResponse | BadRequestResponse;
}
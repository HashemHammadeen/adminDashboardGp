import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import ChartsController from "controllers/charts_controller"
application.register("charts", ChartsController)
eagerLoadControllersFrom("controllers", application)

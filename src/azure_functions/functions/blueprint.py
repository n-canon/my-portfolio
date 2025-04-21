import azure.functions as func
import logging

blueprintfunc = func.Blueprint()

@blueprintfunc.function_name(name="Mytimer")
@blueprintfunc.timer_trigger(schedule="1 1 1 1 1 1", arg_name="myTimer", run_on_startup=True,
              use_monitor=False) 
def timer_trigger(myTimer: func.TimerRequest) -> None:
    if myTimer.past_due:
        logging.info('The timer is past due!')

    logging.info('Python timer trigger function executed.')
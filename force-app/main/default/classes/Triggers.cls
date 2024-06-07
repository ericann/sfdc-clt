/**
 * @ Author Eric
 * @ Function Trigger management
 * @ Date
 */
public with sharing class Triggers {

    public static Boolean IS_RUN_ONE_TIME = true;
    public static Boolean IS_PASS = false;

    public enum Type {
        BeforeInsert,
        BeforeUpdate,
        BeforeDelete,
        AfterInsert,
        AfterUpdate,
        AfterDelete,
        AfterUnDelete
    }

    private Map<Type, List<Handler>> handlersMapping;
    private Type triggerEvent { 
        get {
            Type triggerEvent = null;

            if(Trigger.isBefore && Trigger.isInsert) {
                triggerEvent = Type.BeforeInsert;
            } else if(Trigger.isBefore && Trigger.isUpdate) {
                triggerEvent = Type.BeforeUpdate;
            } else if(Trigger.isBefore && Trigger.isDelete) {
                triggerEvent = Type.BeforeDelete;
            } else if(Trigger.isAfter && Trigger.isInsert) {
                triggerEvent = Type.AfterInsert;
            } else if(Trigger.isAfter && Trigger.isUpdate) {
                triggerEvent = Type.AfterUpdate;
            } else if(Trigger.isAfter && Trigger.isDelete) {
                triggerEvent = Type.AfterDelete;
            } else if(Trigger.isAfter && Trigger.isUnDelete) {
                triggerEvent = Type.AfterUnDelete;
            }

            return triggerEvent; 
        }
        set;
    }

    public interface Handler {
        void handle();
    }

    public Triggers bind(Type triggerEvent, Handler handler) {
        List<Handler> handlers = this.handlersMapping.get(triggerEvent);

        if(handlers == null) {
            handlers = new List<Handler>();
            this.handlersMapping.put(triggerEvent, handlers);
        }

        handlers.add(handler);

        return this;
    }

    public void manage() {
        for(Handler handler: this.handlersMapping.get(triggerEvent)) {
            handler.handle();
        }
    }

    public Triggers() {
        this.handlersMapping = new Map<Type, List<Handler>>();
    }

    public Triggers(Boolean isRunOneTime, Boolean isPass) {
        this();
        IS_RUN_ONE_TIME = isRunOneTime;
        IS_PASS = isPass;
    }
}
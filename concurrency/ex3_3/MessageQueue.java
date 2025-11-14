import java.util.concurrent.LinkedBlockingQueue;

public class MessageQueue {
    private static int n_ids;

    public static void main(String[] args) {

	int numConsumers = 2;
	int numProducers = 2;
	int time = 10000;

	LinkedBlockingQueue<Message> queue = new LinkedBlockingQueue<Message>(10);

	if (args.length >= 1) {
	    numConsumers = Integer.parseInt(args[0]);
	}
	if (args.length >= 2) {
	    numProducers = Integer.parseInt(args[1]);
	}

	Producer[] producers = new Producer[numProducers];
	Consumer[] consumers = new Consumer[numConsumers];
	Thread[] producerThreads = new Thread[numProducers];
	Thread[] consumerThreads = new Thread[numConsumers];
	

	for (int i = 0; i < numProducers; i++) {
	    producers[i] = new Producer(queue, n_ids++);
	    producerThreads[i] = new Thread(producers[i]);
	    producerThreads[i].start();
	}
	

	for (int i = 0; i < numConsumers; i++) {
	    consumers[i] = new Consumer(queue, n_ids++);
	    consumerThreads[i] = new Thread(consumers[i]);
	    consumerThreads[i].start();
	}
	
	try {
	    Thread.sleep(time);
	} catch (InterruptedException e) {
	    e.printStackTrace();
	}

	for (Producer p : producers) {
	    p.stop();
	}
	
	for (Thread t : producerThreads) {
	    try {
		t.join();
	    } catch (InterruptedException e) {
		e.printStackTrace();
	    }
	}

	for (int i = numProducers; i < numConsumers; i++) {
	    try {
		queue.put(new Message("stop"));
	    } catch (InterruptedException e) {
		e.printStackTrace();
	    }
	}
	
	for (Thread t : consumerThreads) {
	    try {
		t.join();
	    } catch (InterruptedException e) {
		e.printStackTrace();
	    }
	}
    }
}

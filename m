Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E027127E987
	for <lists+linux-fscrypt@lfdr.de>; Wed, 30 Sep 2020 15:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730422AbgI3NZ6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 30 Sep 2020 09:25:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730250AbgI3NZY (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 30 Sep 2020 09:25:24 -0400
Received: from mail.kernel.org (unknown [95.90.213.196])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1959A239EB;
        Wed, 30 Sep 2020 13:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601472321;
        bh=SkRAf3aXhJPyIyXePZRh8IQYHFa9ByPhPs2YlRrjPME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JzGgEILLgVYYKfkgByt/EDwRYyvzZtItz5omkzKyLHhCDvPA8B3tBiBv0c0BRbiAH
         NiZz115Ui/juScHnkfFQcHSkVhHsup3zPLR2jnDt6ZmackwN7W5TluJBPYLO61sUQi
         6Xki4XWEgd0AWTNomAZceJ7UhIS7CTAO+YT2H0X4=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kNc6g-001XJn-Mp; Wed, 30 Sep 2020 15:25:18 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "Alexander A. Klimov" <grandmaster@al2klimov.de>,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mike Rapoport <rppt@kernel.org>,
        Moritz Fischer <mdf@kernel.org>,
        Puranjay Mohan <puranjay12@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Satya Tangirala <satyat@google.com>,
        Takashi Iwai <tiwai@suse.com>, Tom Rix <trix@redhat.com>,
        alsa-devel@alsa-project.org, linux-fpga@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v4 22/52] docs: get rid of :c:type explicit declarations for structs
Date:   Wed, 30 Sep 2020 15:24:45 +0200
Message-Id: <f74a2b4e1c8c475b5a053f5edd9da5a818be4b1f.1601467849.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1601467849.git.mchehab+huawei@kernel.org>
References: <cover.1601467849.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The :c:type:`foo` only works properly with structs before
Sphinx 3.x.

On Sphinx 3.x, structs should now be declared using the
.. c:struct, and referenced via :c:struct tag.

As we now have the automarkup.py macro, that automatically
convert:
	struct foo

into cross-references, let's get rid of that, solving
several warnings when building docs with Sphinx 3.x.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/block/blk-mq.rst                |  8 +++----
 Documentation/block/inline-encryption.rst     |  8 +++----
 Documentation/driver-api/fpga/fpga-bridge.rst |  4 ++--
 Documentation/driver-api/fpga/fpga-mgr.rst    |  4 ++--
 Documentation/driver-api/fpga/fpga-region.rst |  2 +-
 Documentation/driver-api/iio/buffers.rst      |  2 +-
 Documentation/driver-api/iio/core.rst         |  6 ++---
 Documentation/driver-api/iio/hw-consumer.rst  |  2 +-
 .../driver-api/iio/triggered-buffers.rst      |  2 +-
 Documentation/driver-api/iio/triggers.rst     |  4 ++--
 .../driver-api/media/dtv-frontend.rst         |  4 ++--
 Documentation/driver-api/media/mc-core.rst    | 24 +++++++++----------
 .../driver-api/media/v4l2-controls.rst        |  2 +-
 Documentation/driver-api/media/v4l2-dev.rst   |  8 +++----
 .../driver-api/media/v4l2-device.rst          |  6 ++---
 Documentation/driver-api/media/v4l2-event.rst | 10 ++++----
 Documentation/driver-api/media/v4l2-fh.rst    | 16 ++++++-------
 .../driver-api/media/v4l2-subdev.rst          |  2 +-
 Documentation/driver-api/regulator.rst        |  4 ++--
 Documentation/driver-api/usb/URB.rst          |  2 +-
 Documentation/driver-api/usb/gadget.rst       | 10 ++++----
 Documentation/driver-api/usb/hotplug.rst      |  2 +-
 Documentation/filesystems/fscrypt.rst         | 14 +++++------
 Documentation/filesystems/fsverity.rst        |  2 +-
 Documentation/sound/designs/tracepoints.rst   | 22 ++++++++---------
 Documentation/sphinx/parse-headers.pl         |  2 +-
 Documentation/vm/ksm.rst                      |  2 +-
 Documentation/vm/memory-model.rst             |  6 ++---
 mm/ksm.c                                      |  2 +-
 mm/memblock.c                                 |  4 ++--
 30 files changed, 93 insertions(+), 93 deletions(-)

diff --git a/Documentation/block/blk-mq.rst b/Documentation/block/blk-mq.rst
index 88c56afcb070..86a632af02b0 100644
--- a/Documentation/block/blk-mq.rst
+++ b/Documentation/block/blk-mq.rst
@@ -63,10 +63,10 @@ Software staging queues
 ~~~~~~~~~~~~~~~~~~~~~~~
 
 The block IO subsystem adds requests  in the software staging queues
-(represented by struct :c:type:`blk_mq_ctx`) in case that they weren't sent
+(represented by struct blk_mq_ctx) in case that they weren't sent
 directly to the driver. A request is one or more BIOs. They arrived at the
-block layer through the data structure struct :c:type:`bio`. The block layer
-will then build a new structure from it, the struct :c:type:`request` that will
+block layer through the data structure struct bio. The block layer
+will then build a new structure from it, the struct request that will
 be used to communicate with the device driver. Each queue has its own lock and
 the number of queues is defined by a per-CPU or per-node basis.
 
@@ -102,7 +102,7 @@ hardware queue will be drained in sequence according to their mapping.
 Hardware dispatch queues
 ~~~~~~~~~~~~~~~~~~~~~~~~
 
-The hardware queue (represented by struct :c:type:`blk_mq_hw_ctx`) is a struct
+The hardware queue (represented by struct blk_mq_hw_ctx) is a struct
 used by device drivers to map the device submission queues (or device DMA ring
 buffer), and are the last step of the block layer submission code before the
 low level device driver taking ownership of the request. To run this queue, the
diff --git a/Documentation/block/inline-encryption.rst b/Documentation/block/inline-encryption.rst
index 354817b80887..e75151e467d3 100644
--- a/Documentation/block/inline-encryption.rst
+++ b/Documentation/block/inline-encryption.rst
@@ -52,7 +52,7 @@ Constraints and notes
 Design
 ======
 
-We add a :c:type:`struct bio_crypt_ctx` to :c:type:`struct bio` that can
+We add a struct bio_crypt_ctx to struct bio that can
 represent an encryption context, because we need to be able to pass this
 encryption context from the upper layers (like the fs layer) to the
 device driver to act upon.
@@ -85,7 +85,7 @@ blk-mq changes, other block layer changes and blk-crypto-fallback
 =================================================================
 
 We add a pointer to a ``bi_crypt_context`` and ``keyslot`` to
-:c:type:`struct request`. These will be referred to as the ``crypto fields``
+struct request. These will be referred to as the ``crypto fields``
 for the request. This ``keyslot`` is the keyslot into which the
 ``bi_crypt_context`` has been programmed in the KSM of the ``request_queue``
 that this request is being sent to.
@@ -118,7 +118,7 @@ of the algorithm being used adheres to spec and functions correctly).
 If a ``request queue``'s inline encryption hardware claimed to support the
 encryption context specified with a bio, then it will not be handled by the
 ``blk-crypto-fallback``. We will eventually reach a point in blk-mq when a
-:c:type:`struct request` needs to be allocated for that bio. At that point,
+struct request needs to be allocated for that bio. At that point,
 blk-mq tries to program the encryption context into the ``request_queue``'s
 keyslot_manager, and obtain a keyslot, which it stores in its newly added
 ``keyslot`` field. This keyslot is released when the request is completed.
@@ -188,7 +188,7 @@ keyslots supported by the hardware.
 The device driver also needs to tell the KSM how to actually manipulate the
 IE hardware in the device to do things like programming the crypto key into
 the IE hardware into a particular keyslot. All this is achieved through the
-:c:type:`struct blk_ksm_ll_ops` field in the KSM that the device driver
+struct blk_ksm_ll_ops field in the KSM that the device driver
 must fill up after initing the ``blk_keyslot_manager``.
 
 The KSM also handles runtime power management for the device when applicable
diff --git a/Documentation/driver-api/fpga/fpga-bridge.rst b/Documentation/driver-api/fpga/fpga-bridge.rst
index ccd677ba7d76..198aadafd3e7 100644
--- a/Documentation/driver-api/fpga/fpga-bridge.rst
+++ b/Documentation/driver-api/fpga/fpga-bridge.rst
@@ -4,8 +4,8 @@ FPGA Bridge
 API to implement a new FPGA bridge
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-* struct :c:type:`fpga_bridge` — The FPGA Bridge structure
-* struct :c:type:`fpga_bridge_ops` — Low level Bridge driver ops
+* struct fpga_bridge — The FPGA Bridge structure
+* struct fpga_bridge_ops — Low level Bridge driver ops
 * devm_fpga_bridge_create() — Allocate and init a bridge struct
 * fpga_bridge_register() — Register a bridge
 * fpga_bridge_unregister() — Unregister a bridge
diff --git a/Documentation/driver-api/fpga/fpga-mgr.rst b/Documentation/driver-api/fpga/fpga-mgr.rst
index af5382af1379..22f7885b32c9 100644
--- a/Documentation/driver-api/fpga/fpga-mgr.rst
+++ b/Documentation/driver-api/fpga/fpga-mgr.rst
@@ -102,8 +102,8 @@ API for implementing a new FPGA Manager driver
 ----------------------------------------------
 
 * ``fpga_mgr_states`` —  Values for :c:member:`fpga_manager->state`.
-* struct :c:type:`fpga_manager` —  the FPGA manager struct
-* struct :c:type:`fpga_manager_ops` —  Low level FPGA manager driver ops
+* struct fpga_manager —  the FPGA manager struct
+* struct fpga_manager_ops —  Low level FPGA manager driver ops
 * devm_fpga_mgr_create() —  Allocate and init a manager struct
 * fpga_mgr_register() —  Register an FPGA manager
 * fpga_mgr_unregister() —  Unregister an FPGA manager
diff --git a/Documentation/driver-api/fpga/fpga-region.rst b/Documentation/driver-api/fpga/fpga-region.rst
index 31118a8ba218..3e52be7e2968 100644
--- a/Documentation/driver-api/fpga/fpga-region.rst
+++ b/Documentation/driver-api/fpga/fpga-region.rst
@@ -45,7 +45,7 @@ An example of usage can be seen in the probe function of [#f2]_.
 API to add a new FPGA region
 ----------------------------
 
-* struct :c:type:`fpga_region` — The FPGA region struct
+* struct fpga_region — The FPGA region struct
 * devm_fpga_region_create() — Allocate and init a region struct
 * fpga_region_register() —  Register an FPGA region
 * fpga_region_unregister() —  Unregister an FPGA region
diff --git a/Documentation/driver-api/iio/buffers.rst b/Documentation/driver-api/iio/buffers.rst
index dd64c9c5fb1e..3ddebddc02ca 100644
--- a/Documentation/driver-api/iio/buffers.rst
+++ b/Documentation/driver-api/iio/buffers.rst
@@ -2,7 +2,7 @@
 Buffers
 =======
 
-* struct :c:type:`iio_buffer` — general buffer structure
+* struct iio_buffer — general buffer structure
 * :c:func:`iio_validate_scan_mask_onehot` — Validates that exactly one channel
   is selected
 * :c:func:`iio_buffer_get` — Grab a reference to the buffer
diff --git a/Documentation/driver-api/iio/core.rst b/Documentation/driver-api/iio/core.rst
index 51b21e002396..715cf29482a1 100644
--- a/Documentation/driver-api/iio/core.rst
+++ b/Documentation/driver-api/iio/core.rst
@@ -10,7 +10,7 @@ applications manipulating sensors. The implementation can be found under
 Industrial I/O Devices
 ----------------------
 
-* struct :c:type:`iio_dev` - industrial I/O device
+* struct iio_dev - industrial I/O device
 * iio_device_alloc() - allocate an :c:type:`iio_dev` from a driver
 * iio_device_free() - free an :c:type:`iio_dev` from a driver
 * iio_device_register() - register a device with the IIO subsystem
@@ -66,7 +66,7 @@ Common attributes are:
 IIO device channels
 ===================
 
-struct :c:type:`iio_chan_spec` - specification of a single channel
+struct iio_chan_spec - specification of a single channel
 
 An IIO device channel is a representation of a data channel. An IIO device can
 have one or multiple channels. For example:
@@ -77,7 +77,7 @@ have one or multiple channels. For example:
 * an accelerometer can have up to 3 channels representing acceleration on X, Y
   and Z axes.
 
-An IIO channel is described by the struct :c:type:`iio_chan_spec`.
+An IIO channel is described by the struct iio_chan_spec.
 A thermometer driver for the temperature sensor in the example above would
 have to describe its channel as follows::
 
diff --git a/Documentation/driver-api/iio/hw-consumer.rst b/Documentation/driver-api/iio/hw-consumer.rst
index 819fb9edc005..76133a3796f2 100644
--- a/Documentation/driver-api/iio/hw-consumer.rst
+++ b/Documentation/driver-api/iio/hw-consumer.rst
@@ -8,7 +8,7 @@ software buffer for data. The implementation can be found under
 :file:`drivers/iio/buffer/hw-consumer.c`
 
 
-* struct :c:type:`iio_hw_consumer` — Hardware consumer structure
+* struct iio_hw_consumer — Hardware consumer structure
 * :c:func:`iio_hw_consumer_alloc` — Allocate IIO hardware consumer
 * :c:func:`iio_hw_consumer_free` — Free IIO hardware consumer
 * :c:func:`iio_hw_consumer_enable` — Enable IIO hardware consumer
diff --git a/Documentation/driver-api/iio/triggered-buffers.rst b/Documentation/driver-api/iio/triggered-buffers.rst
index 0db12660cc90..417555dbbdf4 100644
--- a/Documentation/driver-api/iio/triggered-buffers.rst
+++ b/Documentation/driver-api/iio/triggered-buffers.rst
@@ -10,7 +10,7 @@ IIO triggered buffer setup
 * :c:func:`iio_triggered_buffer_setup` — Setup triggered buffer and pollfunc
 * :c:func:`iio_triggered_buffer_cleanup` — Free resources allocated by
   :c:func:`iio_triggered_buffer_setup`
-* struct :c:type:`iio_buffer_setup_ops` — buffer setup related callbacks
+* struct iio_buffer_setup_ops — buffer setup related callbacks
 
 A typical triggered buffer setup looks like this::
 
diff --git a/Documentation/driver-api/iio/triggers.rst b/Documentation/driver-api/iio/triggers.rst
index dfd7ba3eabde..288625e40672 100644
--- a/Documentation/driver-api/iio/triggers.rst
+++ b/Documentation/driver-api/iio/triggers.rst
@@ -2,7 +2,7 @@
 Triggers
 ========
 
-* struct :c:type:`iio_trigger` — industrial I/O trigger device
+* struct iio_trigger — industrial I/O trigger device
 * :c:func:`devm_iio_trigger_alloc` — Resource-managed iio_trigger_alloc
 * :c:func:`devm_iio_trigger_register` — Resource-managed iio_trigger_register
   iio_trigger_unregister
@@ -63,7 +63,7 @@ Let's see a simple example of how to setup a trigger to be used by a driver::
 IIO trigger ops
 ===============
 
-* struct :c:type:`iio_trigger_ops` — operations structure for an iio_trigger.
+* struct iio_trigger_ops — operations structure for an iio_trigger.
 
 Notice that a trigger has a set of operations attached:
 
diff --git a/Documentation/driver-api/media/dtv-frontend.rst b/Documentation/driver-api/media/dtv-frontend.rst
index b362109bb131..91f77fe58e83 100644
--- a/Documentation/driver-api/media/dtv-frontend.rst
+++ b/Documentation/driver-api/media/dtv-frontend.rst
@@ -125,7 +125,7 @@ responsible for tuning the device. It supports multiple algorithms to
 detect a channel, as defined at enum :c:func:`dvbfe_algo`.
 
 The algorithm to be used is obtained via ``.get_frontend_algo``. If the driver
-doesn't fill its field at struct :c:type:`dvb_frontend_ops`, it will default to
+doesn't fill its field at struct dvb_frontend_ops, it will default to
 ``DVBFE_ALGO_SW``, meaning that the dvb-core will do a zigzag when tuning,
 e. g. it will try first to use the specified center frequency ``f``,
 then, it will do ``f`` + |delta|, ``f`` - |delta|, ``f`` + 2 x |delta|,
@@ -140,7 +140,7 @@ define a ``.get_frontend_algo`` function that would return ``DVBFE_ALGO_HW``.
    a third type (``DVBFE_ALGO_CUSTOM``), in order to allow the driver to
    define its own hardware-assisted algorithm. Very few hardware need to
    use it nowadays. Using ``DVBFE_ALGO_CUSTOM`` require to provide other
-   function callbacks at struct :c:type:`dvb_frontend_ops`.
+   function callbacks at struct dvb_frontend_ops.
 
 Attaching frontend driver to the bridge driver
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
diff --git a/Documentation/driver-api/media/mc-core.rst b/Documentation/driver-api/media/mc-core.rst
index 05bba0b61748..57b5bbba944e 100644
--- a/Documentation/driver-api/media/mc-core.rst
+++ b/Documentation/driver-api/media/mc-core.rst
@@ -36,7 +36,7 @@ pad to a sink pad.
 Media device
 ^^^^^^^^^^^^
 
-A media device is represented by a struct :c:type:`media_device`
+A media device is represented by a struct media_device
 instance, defined in ``include/media/media-device.h``.
 Allocation of the structure is handled by the media device driver, usually by
 embedding the :c:type:`media_device` instance in a larger driver-specific
@@ -49,7 +49,7 @@ and unregistered by calling :c:func:`media_device_unregister()`.
 Entities
 ^^^^^^^^
 
-Entities are represented by a struct :c:type:`media_entity`
+Entities are represented by a struct media_entity
 instance, defined in ``include/media/media-entity.h``. The structure is usually
 embedded into a higher-level structure, such as
 :c:type:`v4l2_subdev` or :c:type:`video_device`
@@ -67,10 +67,10 @@ Interfaces
 ^^^^^^^^^^
 
 Interfaces are represented by a
-struct :c:type:`media_interface` instance, defined in
+struct media_interface instance, defined in
 ``include/media/media-entity.h``. Currently, only one type of interface is
 defined: a device node. Such interfaces are represented by a
-struct :c:type:`media_intf_devnode`.
+struct media_intf_devnode.
 
 Drivers initialize and create device node interfaces by calling
 :c:func:`media_devnode_create()`
@@ -79,7 +79,7 @@ and remove them by calling:
 
 Pads
 ^^^^
-Pads are represented by a struct :c:type:`media_pad` instance,
+Pads are represented by a struct media_pad instance,
 defined in ``include/media/media-entity.h``. Each entity stores its pads in
 a pads array managed by the entity driver. Drivers usually embed the array in
 a driver-specific structure.
@@ -87,8 +87,8 @@ a driver-specific structure.
 Pads are identified by their entity and their 0-based index in the pads
 array.
 
-Both information are stored in the struct :c:type:`media_pad`,
-making the struct :c:type:`media_pad` pointer the canonical way
+Both information are stored in the struct media_pad,
+making the struct media_pad pointer the canonical way
 to store and pass link references.
 
 Pads have flags that describe the pad capabilities and state.
@@ -104,7 +104,7 @@ Pads have flags that describe the pad capabilities and state.
 Links
 ^^^^^
 
-Links are represented by a struct :c:type:`media_link` instance,
+Links are represented by a struct media_link instance,
 defined in ``include/media/media-entity.h``. There are two types of links:
 
 **1. pad to pad links**:
@@ -187,7 +187,7 @@ Use count and power handling
 
 Due to the wide differences between drivers regarding power management
 needs, the media controller does not implement power management. However,
-the struct :c:type:`media_entity` includes a ``use_count``
+the struct media_entity includes a ``use_count``
 field that media drivers
 can use to track the number of users of every entity for power management
 needs.
@@ -213,11 +213,11 @@ prevent link states from being modified during streaming by calling
 The function will mark all entities connected to the given entity through
 enabled links, either directly or indirectly, as streaming.
 
-The struct :c:type:`media_pipeline` instance pointed to by
+The struct media_pipeline instance pointed to by
 the pipe argument will be stored in every entity in the pipeline.
-Drivers should embed the struct :c:type:`media_pipeline`
+Drivers should embed the struct media_pipeline
 in higher-level pipeline structures and can then access the
-pipeline through the struct :c:type:`media_entity`
+pipeline through the struct media_entity
 pipe field.
 
 Calls to :c:func:`media_pipeline_start()` can be nested.
diff --git a/Documentation/driver-api/media/v4l2-controls.rst b/Documentation/driver-api/media/v4l2-controls.rst
index 5129019afb49..77f42ea3bac7 100644
--- a/Documentation/driver-api/media/v4l2-controls.rst
+++ b/Documentation/driver-api/media/v4l2-controls.rst
@@ -27,7 +27,7 @@ V4L2 specification with respect to controls in a central place. And to make
 life as easy as possible for the driver developer.
 
 Note that the control framework relies on the presence of a struct
-:c:type:`v4l2_device` for V4L2 drivers and struct :c:type:`v4l2_subdev` for
+:c:type:`v4l2_device` for V4L2 drivers and struct v4l2_subdev for
 sub-device drivers.
 
 
diff --git a/Documentation/driver-api/media/v4l2-dev.rst b/Documentation/driver-api/media/v4l2-dev.rst
index 63c064837c00..666330af31ed 100644
--- a/Documentation/driver-api/media/v4l2-dev.rst
+++ b/Documentation/driver-api/media/v4l2-dev.rst
@@ -67,7 +67,7 @@ You should also set these fields of :c:type:`video_device`:
   file operation is called this lock will be taken by the core and released
   afterwards. See the next section for more details.
 
-- :c:type:`video_device`->queue: a pointer to the struct :c:type:`vb2_queue`
+- :c:type:`video_device`->queue: a pointer to the struct vb2_queue
   associated with this device node.
   If queue is not ``NULL``, and queue->lock is not ``NULL``, then queue->lock
   is used for the queuing ioctls (``VIDIOC_REQBUFS``, ``CREATE_BUFS``,
@@ -81,7 +81,7 @@ You should also set these fields of :c:type:`video_device`:
 
 - :c:type:`video_device`->prio: keeps track of the priorities. Used to
   implement ``VIDIOC_G_PRIORITY`` and ``VIDIOC_S_PRIORITY``.
-  If left to ``NULL``, then it will use the struct :c:type:`v4l2_prio_state`
+  If left to ``NULL``, then it will use the struct v4l2_prio_state
   in :c:type:`v4l2_device`. If you want to have a separate priority state per
   (group of) device node(s),   then you can point it to your own struct
   :c:type:`v4l2_prio_state`.
@@ -95,7 +95,7 @@ You should also set these fields of :c:type:`video_device`:
   but   it is used by both a raw video PCI device (cx8800) and a MPEG PCI device
   (cx8802). Since the :c:type:`v4l2_device` cannot be associated with two PCI
   devices at the same time it is setup without a parent device. But when the
-  struct :c:type:`video_device` is initialized you **do** know which parent
+  struct video_device is initialized you **do** know which parent
   PCI device to use and so you set ``dev_device`` to the correct PCI device.
 
 If you use :c:type:`v4l2_ioctl_ops`, then you should set
@@ -138,7 +138,7 @@ ioctls and locking
 ------------------
 
 The V4L core provides optional locking services. The main service is the
-lock field in struct :c:type:`video_device`, which is a pointer to a mutex.
+lock field in struct video_device, which is a pointer to a mutex.
 If you set this pointer, then that will be used by unlocked_ioctl to
 serialize all ioctls.
 
diff --git a/Documentation/driver-api/media/v4l2-device.rst b/Documentation/driver-api/media/v4l2-device.rst
index 5e25bf182c18..7bd9c45f551b 100644
--- a/Documentation/driver-api/media/v4l2-device.rst
+++ b/Documentation/driver-api/media/v4l2-device.rst
@@ -3,7 +3,7 @@
 V4L2 device instance
 --------------------
 
-Each device instance is represented by a struct :c:type:`v4l2_device`.
+Each device instance is represented by a struct v4l2_device.
 Very simple devices can just allocate this struct, but most of the time you
 would embed this struct inside a larger struct.
 
@@ -18,9 +18,9 @@ dev->driver_data field is ``NULL``, it will be linked to
 
 Drivers that want integration with the media device framework need to set
 dev->driver_data manually to point to the driver-specific device structure
-that embed the struct :c:type:`v4l2_device` instance. This is achieved by a
+that embed the struct v4l2_device instance. This is achieved by a
 ``dev_set_drvdata()`` call before registering the V4L2 device instance.
-They must also set the struct :c:type:`v4l2_device` mdev field to point to a
+They must also set the struct v4l2_device mdev field to point to a
 properly initialized and registered :c:type:`media_device` instance.
 
 If :c:type:`v4l2_dev <v4l2_device>`\ ->name is empty then it will be set to a
diff --git a/Documentation/driver-api/media/v4l2-event.rst b/Documentation/driver-api/media/v4l2-event.rst
index a4b7ae2b94d8..5b8254eba7da 100644
--- a/Documentation/driver-api/media/v4l2-event.rst
+++ b/Documentation/driver-api/media/v4l2-event.rst
@@ -44,18 +44,18 @@ such objects.
 
 So to summarize:
 
-- struct :c:type:`v4l2_fh` has two lists: one of the ``subscribed`` events,
+- struct v4l2_fh has two lists: one of the ``subscribed`` events,
   and one of the ``available`` events.
 
-- struct :c:type:`v4l2_subscribed_event` has a ringbuffer of raised
+- struct v4l2_subscribed_event has a ringbuffer of raised
   (pending) events of that particular type.
 
-- If struct :c:type:`v4l2_subscribed_event` is associated with a specific
+- If struct v4l2_subscribed_event is associated with a specific
   object, then that object will have an internal list of
-  struct :c:type:`v4l2_subscribed_event` so it knows who subscribed an
+  struct v4l2_subscribed_event so it knows who subscribed an
   event to that object.
 
-Furthermore, the internal struct :c:type:`v4l2_subscribed_event` has
+Furthermore, the internal struct v4l2_subscribed_event has
 ``merge()`` and ``replace()`` callbacks which drivers can set. These
 callbacks are called when a new event is raised and there is no more room.
 
diff --git a/Documentation/driver-api/media/v4l2-fh.rst b/Documentation/driver-api/media/v4l2-fh.rst
index 4c62b19af744..3eeaa8da0c9e 100644
--- a/Documentation/driver-api/media/v4l2-fh.rst
+++ b/Documentation/driver-api/media/v4l2-fh.rst
@@ -3,11 +3,11 @@
 V4L2 File handlers
 ------------------
 
-struct :c:type:`v4l2_fh` provides a way to easily keep file handle specific
+struct v4l2_fh provides a way to easily keep file handle specific
 data that is used by the V4L2 framework.
 
 .. attention::
-	New drivers must use struct :c:type:`v4l2_fh`
+	New drivers must use struct v4l2_fh
 	since it is also used to implement priority handling
 	(:ref:`VIDIOC_G_PRIORITY`).
 
@@ -16,11 +16,11 @@ whether a driver uses :c:type:`v4l2_fh` as its ``file->private_data`` pointer
 by testing the ``V4L2_FL_USES_V4L2_FH`` bit in :c:type:`video_device`->flags.
 This bit is set whenever :c:func:`v4l2_fh_init` is called.
 
-struct :c:type:`v4l2_fh` is allocated as a part of the driver's own file handle
+struct v4l2_fh is allocated as a part of the driver's own file handle
 structure and ``file->private_data`` is set to it in the driver's ``open()``
 function by the driver.
 
-In many cases the struct :c:type:`v4l2_fh` will be embedded in a larger
+In many cases the struct v4l2_fh will be embedded in a larger
 structure. In that case you should call:
 
 #) :c:func:`v4l2_fh_init` and :c:func:`v4l2_fh_add` in ``open()``
@@ -102,18 +102,18 @@ Below is a short description of the :c:type:`v4l2_fh` functions used:
   memory can be freed.
 
 
-If struct :c:type:`v4l2_fh` is not embedded, then you can use these helper functions:
+If struct v4l2_fh is not embedded, then you can use these helper functions:
 
 :c:func:`v4l2_fh_open <v4l2_fh_open>`
 (struct file \*filp)
 
-- This allocates a struct :c:type:`v4l2_fh`, initializes it and adds it to
-  the struct :c:type:`video_device` associated with the file struct.
+- This allocates a struct v4l2_fh, initializes it and adds it to
+  the struct video_device associated with the file struct.
 
 :c:func:`v4l2_fh_release <v4l2_fh_release>`
 (struct file \*filp)
 
-- This deletes it from the struct :c:type:`video_device` associated with the
+- This deletes it from the struct video_device associated with the
   file struct, uninitialised the :c:type:`v4l2_fh` and frees it.
 
 These two functions can be plugged into the v4l2_file_operation's ``open()``
diff --git a/Documentation/driver-api/media/v4l2-subdev.rst b/Documentation/driver-api/media/v4l2-subdev.rst
index 6248ea99e979..bb5b1a7cdfd9 100644
--- a/Documentation/driver-api/media/v4l2-subdev.rst
+++ b/Documentation/driver-api/media/v4l2-subdev.rst
@@ -110,7 +110,7 @@ pads:
 	err = media_entity_pads_init(&sd->entity, npads, pads);
 
 The pads array must have been previously initialized. There is no need to
-manually set the struct :c:type:`media_entity` function and name fields, but the
+manually set the struct media_entity function and name fields, but the
 revision field must be initialized if needed.
 
 A reference to the entity will be automatically acquired/released when the
diff --git a/Documentation/driver-api/regulator.rst b/Documentation/driver-api/regulator.rst
index 520da0a5251d..b43c78eb24d8 100644
--- a/Documentation/driver-api/regulator.rst
+++ b/Documentation/driver-api/regulator.rst
@@ -116,7 +116,7 @@ core, providing operations structures to the core. A notifier interface
 allows error conditions to be reported to the core.
 
 Registration should be triggered by explicit setup done by the platform,
-supplying a struct :c:type:`regulator_init_data` for the regulator
+supplying a struct regulator_init_data for the regulator
 containing constraint and supply information.
 
 Machine interface
@@ -144,7 +144,7 @@ a given system, for example supporting higher supply voltages than the
 consumers are rated for.
 
 This is done at driver registration time` by providing a
-struct :c:type:`regulation_constraints`.
+struct regulation_constraints.
 
 The constraints may also specify an initial configuration for the
 regulator in the constraints, which is particularly useful for use with
diff --git a/Documentation/driver-api/usb/URB.rst b/Documentation/driver-api/usb/URB.rst
index 1e4abc896a0d..a182c0f5e38a 100644
--- a/Documentation/driver-api/usb/URB.rst
+++ b/Documentation/driver-api/usb/URB.rst
@@ -47,7 +47,7 @@ called USB Request Block, or URB for short.
 The URB structure
 =================
 
-Some of the fields in struct :c:type:`urb` are::
+Some of the fields in struct urb are::
 
   struct urb
   {
diff --git a/Documentation/driver-api/usb/gadget.rst b/Documentation/driver-api/usb/gadget.rst
index 3e8a3809c0b8..09396edd6131 100644
--- a/Documentation/driver-api/usb/gadget.rst
+++ b/Documentation/driver-api/usb/gadget.rst
@@ -176,9 +176,9 @@ Kernel Mode Gadget API
 
 Gadget drivers declare themselves through a struct
 :c:type:`usb_gadget_driver`, which is responsible for most parts of enumeration
-for a struct :c:type:`usb_gadget`. The response to a set_configuration usually
-involves enabling one or more of the struct :c:type:`usb_ep` objects exposed by
-the gadget, and submitting one or more struct :c:type:`usb_request` buffers to
+for a struct usb_gadget. The response to a set_configuration usually
+involves enabling one or more of the struct usb_ep objects exposed by
+the gadget, and submitting one or more struct usb_request buffers to
 transfer data. Understand those four data types, and their operations,
 and you will understand how this API works.
 
@@ -339,8 +339,8 @@ multi-configuration devices (also more than one function, but not
 necessarily sharing a given configuration). There is however an optional
 framework which makes it easier to reuse and combine functions.
 
-Devices using this framework provide a struct :c:type:`usb_composite_driver`,
-which in turn provides one or more struct :c:type:`usb_configuration`
+Devices using this framework provide a struct usb_composite_driver,
+which in turn provides one or more struct usb_configuration
 instances. Each such configuration includes at least one struct
 :c:type:`usb_function`, which packages a user visible role such as "network
 link" or "mass storage device". Management functions may also exist,
diff --git a/Documentation/driver-api/usb/hotplug.rst b/Documentation/driver-api/usb/hotplug.rst
index 79663e653ca1..c1e13107c50e 100644
--- a/Documentation/driver-api/usb/hotplug.rst
+++ b/Documentation/driver-api/usb/hotplug.rst
@@ -122,7 +122,7 @@ and their quirks, might have a MODULE_DEVICE_TABLE like this::
 Most USB device drivers should pass these tables to the USB subsystem as
 well as to the module management subsystem.  Not all, though: some driver
 frameworks connect using interfaces layered over USB, and so they won't
-need such a struct :c:type:`usb_driver`.
+need such a struct usb_driver.
 
 Drivers that connect directly to the USB subsystem should be declared
 something like this::
diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 423c5a0daf45..4f858b38a412 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -437,7 +437,7 @@ FS_IOC_SET_ENCRYPTION_POLICY
 The FS_IOC_SET_ENCRYPTION_POLICY ioctl sets an encryption policy on an
 empty directory or verifies that a directory or regular file already
 has the specified encryption policy.  It takes in a pointer to a
-:c:type:`struct fscrypt_policy_v1` or a :c:type:`struct
+struct fscrypt_policy_v1 or a :c:type:`struct
 fscrypt_policy_v2`, defined as follows::
 
     #define FSCRYPT_POLICY_V1               0
@@ -508,7 +508,7 @@ This structure must be initialized as follows:
   replaced with ``master_key_identifier``, which is longer and cannot
   be arbitrarily chosen.  Instead, the key must first be added using
   `FS_IOC_ADD_ENCRYPTION_KEY`_.  Then, the ``key_spec.u.identifier``
-  the kernel returned in the :c:type:`struct fscrypt_add_key_arg` must
+  the kernel returned in the struct fscrypt_add_key_arg must
   be used as the ``master_key_identifier`` in the :c:type:`struct
   fscrypt_policy_v2`.
 
@@ -590,7 +590,7 @@ FS_IOC_GET_ENCRYPTION_POLICY_EX
 The FS_IOC_GET_ENCRYPTION_POLICY_EX ioctl retrieves the encryption
 policy, if any, for a directory or regular file.  No additional
 permissions are required beyond the ability to open the file.  It
-takes in a pointer to a :c:type:`struct fscrypt_get_policy_ex_arg`,
+takes in a pointer to a struct fscrypt_get_policy_ex_arg,
 defined as follows::
 
     struct fscrypt_get_policy_ex_arg {
@@ -680,7 +680,7 @@ the filesystem, making all files on the filesystem which were
 encrypted using that key appear "unlocked", i.e. in plaintext form.
 It can be executed on any file or directory on the target filesystem,
 but using the filesystem's root directory is recommended.  It takes in
-a pointer to a :c:type:`struct fscrypt_add_key_arg`, defined as
+a pointer to a struct fscrypt_add_key_arg, defined as
 follows::
 
     struct fscrypt_add_key_arg {
@@ -710,7 +710,7 @@ follows::
             __u8 raw[];
     };
 
-:c:type:`struct fscrypt_add_key_arg` must be zeroed, then initialized
+struct fscrypt_add_key_arg must be zeroed, then initialized
 as follows:
 
 - If the key is being added for use by v1 encryption policies, then
@@ -860,7 +860,7 @@ The FS_IOC_REMOVE_ENCRYPTION_KEY ioctl removes a claim to a master
 encryption key from the filesystem, and possibly removes the key
 itself.  It can be executed on any file or directory on the target
 filesystem, but using the filesystem's root directory is recommended.
-It takes in a pointer to a :c:type:`struct fscrypt_remove_key_arg`,
+It takes in a pointer to a struct fscrypt_remove_key_arg,
 defined as follows::
 
     struct fscrypt_remove_key_arg {
@@ -1149,7 +1149,7 @@ Encryption context
 ------------------
 
 An encryption policy is represented on-disk by a :c:type:`struct
-fscrypt_context_v1` or a :c:type:`struct fscrypt_context_v2`.  It is
+fscrypt_context_v1` or a struct fscrypt_context_v2.  It is
 up to individual filesystems to decide where to store it, but normally
 it would be stored in a hidden extended attribute.  It should *not* be
 exposed by the xattr-related system calls such as getxattr() and
diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
index 6c8944f6f0f7..895e9711ed88 100644
--- a/Documentation/filesystems/fsverity.rst
+++ b/Documentation/filesystems/fsverity.rst
@@ -84,7 +84,7 @@ FS_IOC_ENABLE_VERITY
 --------------------
 
 The FS_IOC_ENABLE_VERITY ioctl enables fs-verity on a file.  It takes
-in a pointer to a :c:type:`struct fsverity_enable_arg`, defined as
+in a pointer to a struct fsverity_enable_arg, defined as
 follows::
 
     struct fsverity_enable_arg {
diff --git a/Documentation/sound/designs/tracepoints.rst b/Documentation/sound/designs/tracepoints.rst
index 78bc5572f829..b0a7e3010187 100644
--- a/Documentation/sound/designs/tracepoints.rst
+++ b/Documentation/sound/designs/tracepoints.rst
@@ -34,20 +34,20 @@ substream. In this procedure, PCM hardware parameters are decided by
 interaction between applications and ALSA PCM core. Once decided, runtime of
 the PCM substream keeps the parameters.
 
-The parameters are described in :c:type:`struct snd_pcm_hw_params`. This
+The parameters are described in struct snd_pcm_hw_params. This
 structure includes several types of parameters. Applications set preferable
 value to these parameters, then execute ioctl(2) with SNDRV_PCM_IOCTL_HW_REFINE
 or SNDRV_PCM_IOCTL_HW_PARAMS. The former is used just for refining available
 set of parameters. The latter is used for an actual decision of the parameters.
 
-The :c:type:`struct snd_pcm_hw_params` structure has below members:
+The struct snd_pcm_hw_params structure has below members:
 
 ``flags``
         Configurable. ALSA PCM core and some drivers handle this flag to select
         convenient parameters or change their behaviour.
 ``masks``
         Configurable. This type of parameter is described in
-        :c:type:`struct snd_mask` and represent mask values. As of PCM protocol
+        struct snd_mask and represent mask values. As of PCM protocol
         v2.0.13, three types are defined.
 
         - SNDRV_PCM_HW_PARAM_ACCESS
@@ -55,7 +55,7 @@ The :c:type:`struct snd_pcm_hw_params` structure has below members:
         - SNDRV_PCM_HW_PARAM_SUBFORMAT
 ``intervals``
         Configurable. This type of parameter is described in
-        :c:type:`struct snd_interval` and represent values with a range. As of
+        struct snd_interval and represent values with a range. As of
         PCM protocol v2.0.13, twelve types are defined.
 
         - SNDRV_PCM_HW_PARAM_SAMPLE_BITS
@@ -78,7 +78,7 @@ The :c:type:`struct snd_pcm_hw_params` structure has below members:
         are going to be changed.
 ``cmask``
         Read-only. After returning from ioctl(2), buffer in user space for
-        :c:type:`struct snd_pcm_hw_params` includes result of each operation.
+        struct snd_pcm_hw_params includes result of each operation.
         This mask represents which mask/interval parameter is actually changed.
 ``info``
         Read-only. This represents hardware/driver capabilities as bit flags
@@ -110,10 +110,10 @@ The :c:type:`struct snd_pcm_hw_params` structure has below members:
         value to this parameter but some drivers intentionally set zero with
         a care of hardware design or data transmission protocol.
 
-ALSA PCM core handles buffer of :c:type:`struct snd_pcm_hw_params` when
+ALSA PCM core handles buffer of struct snd_pcm_hw_params when
 applications execute ioctl(2) with SNDRV_PCM_HW_REFINE or SNDRV_PCM_HW_PARAMS.
 Parameters in the buffer are changed according to
-:c:type:`struct snd_pcm_hardware` and rules of constraints in the runtime. The
+struct snd_pcm_hardware and rules of constraints in the runtime. The
 structure describes capabilities of handled hardware. The rules describes
 dependencies on which a parameter is decided according to several parameters.
 A rule has a callback function, and drivers can register arbitrary functions
@@ -121,17 +121,17 @@ to compute the target parameter. ALSA PCM core registers some rules to the
 runtime as a default.
 
 Each driver can join in the interaction as long as it prepared for two stuffs
-in a callback of :c:type:`struct snd_pcm_ops.open`.
+in a callback of struct snd_pcm_ops.open.
 
 1. In the callback, drivers are expected to change a member of
-   :c:type:`struct snd_pcm_hardware` type in the runtime, according to
+   struct snd_pcm_hardware type in the runtime, according to
    capacities of corresponding hardware.
 2. In the same callback, drivers are also expected to register additional rules
    of constraints into the runtime when several parameters have dependencies
    due to hardware design.
 
 The driver can refers to result of the interaction in a callback of
-:c:type:`struct snd_pcm_ops.hw_params`, however it should not change the
+struct snd_pcm_ops.hw_params, however it should not change the
 content.
 
 Tracepoints in this category are designed to trace changes of the
@@ -163,7 +163,7 @@ fields are different according to type of the parameter. For parameters of mask
 type, the fields represent hexadecimal dump of content of the parameter. For
 parameters of interval type, the fields represent values of each member of
 ``empty``, ``integer``, ``openmin``, ``min``, ``max``, ``openmax`` in
-:c:type:`struct snd_interval` in this order.
+struct snd_interval in this order.
 
 Tracepoints in drivers
 ======================
diff --git a/Documentation/sphinx/parse-headers.pl b/Documentation/sphinx/parse-headers.pl
index 00a69aceff44..1910079f984f 100755
--- a/Documentation/sphinx/parse-headers.pl
+++ b/Documentation/sphinx/parse-headers.pl
@@ -110,7 +110,7 @@ while (<IN>) {
 	    ) {
 		my $s = $1;
 
-		$structs{$s} = "struct :c:type:`$s`\\ ";
+		$structs{$s} = "struct $s\\ ";
 		next;
 	}
 }
diff --git a/Documentation/vm/ksm.rst b/Documentation/vm/ksm.rst
index d1b7270ad55c..9e37add068e6 100644
--- a/Documentation/vm/ksm.rst
+++ b/Documentation/vm/ksm.rst
@@ -26,7 +26,7 @@ tree.
 
 If a KSM page is shared between less than ``max_page_sharing`` VMAs,
 the node of the stable tree that represents such KSM page points to a
-list of :c:type:`struct rmap_item` and the ``page->mapping`` of the
+list of struct rmap_item and the ``page->mapping`` of the
 KSM page points to the stable tree node.
 
 When the sharing passes this threshold, KSM adds a second dimension to
diff --git a/Documentation/vm/memory-model.rst b/Documentation/vm/memory-model.rst
index 769449734573..9daadf9faba1 100644
--- a/Documentation/vm/memory-model.rst
+++ b/Documentation/vm/memory-model.rst
@@ -24,7 +24,7 @@ whether it is possible to manually override that default.
    although it is still in use by several architectures.
 
 All the memory models track the status of physical page frames using
-:c:type:`struct page` arranged in one or more arrays.
+struct page arranged in one or more arrays.
 
 Regardless of the selected memory model, there exists one-to-one
 mapping between the physical page frame number (PFN) and the
@@ -111,7 +111,7 @@ maps for non-volatile memory devices and deferred initialization of
 the memory map for larger systems.
 
 The SPARSEMEM model presents the physical memory as a collection of
-sections. A section is represented with :c:type:`struct mem_section`
+sections. A section is represented with struct mem_section
 that contains `section_mem_map` that is, logically, a pointer to an
 array of struct pages. However, it is stored with some other magic
 that aids the sections management. The section size and maximal number
@@ -172,7 +172,7 @@ management.
 
 The virtually mapped memory map allows storing `struct page` objects
 for persistent memory devices in pre-allocated storage on those
-devices. This storage is represented with :c:type:`struct vmem_altmap`
+devices. This storage is represented with struct vmem_altmap
 that is eventually passed to vmemmap_populate() through a long chain
 of function calls. The vmemmap_populate() implementation may use the
 `vmem_altmap` along with :c:func:`vmemmap_alloc_block_buf` helper to
diff --git a/mm/ksm.c b/mm/ksm.c
index 9afccc36dbd2..0960750bb316 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -81,7 +81,7 @@
  *   different KSM page copy of that content
  *
  * Internally, the regular nodes, "dups" and "chains" are represented
- * using the same :c:type:`struct stable_node` structure.
+ * using the same struct stable_node structure.
  *
  * In addition to the stable tree, KSM uses a second data structure called the
  * unstable tree: this tree holds pointers to pages which have been found to
diff --git a/mm/memblock.c b/mm/memblock.c
index 326c6b3fec1d..b68ee86788af 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -48,12 +48,12 @@
  *   boot regardless of the possible restrictions and memory hot(un)plug;
  *   the ``physmem`` type is only available on some architectures.
  *
- * Each region is represented by :c:type:`struct memblock_region` that
+ * Each region is represented by struct memblock_region that
  * defines the region extents, its attributes and NUMA node id on NUMA
  * systems. Every memory type is described by the struct memblock_type
  * which contains an array of memory regions along with
  * the allocator metadata. The "memory" and "reserved" types are nicely
- * wrapped with :c:type:`struct memblock`. This structure is statically
+ * wrapped with struct memblock. This structure is statically
  * initialized at build time. The region arrays are initially sized to
  * %INIT_MEMBLOCK_REGIONS for "memory" and %INIT_MEMBLOCK_RESERVED_REGIONS
  * for "reserved". The region array for "physmem" is initially sized to
-- 
2.26.2


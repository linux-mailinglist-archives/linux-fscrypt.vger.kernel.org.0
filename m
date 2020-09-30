Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC1427EFEC
	for <lists+linux-fscrypt@lfdr.de>; Wed, 30 Sep 2020 19:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgI3RGk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 30 Sep 2020 13:06:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI3RGk (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 30 Sep 2020 13:06:40 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0B3620754;
        Wed, 30 Sep 2020 17:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601485599;
        bh=pfFqKmno0xxxC7k8EPmb9aW9qRKFhPRyCWbExsn4vvM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o4EOLMWFTqY+DVkl67iBDF4Opq+llI4PVMKDzrU4owMyYQXWgk8e7t11/ijJR1L5A
         7kwJ0xBX3zy44ncyDjLMOPRKbBRfkh9yp1eUCR9/vGTnfs3qYB7JOVEGFlJ4E9bd4V
         0HxBWkKB4UDtMhPFDkD6eodbKFgt3Pma9GrPQQwQ=
Date:   Wed, 30 Sep 2020 10:06:37 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 35/52] docs: fs: fscrypt.rst: get rid of :c:type: tags
Message-ID: <20200930170637.GB9698@sol.localdomain>
References: <cover.1601467849.git.mchehab+huawei@kernel.org>
 <689d790237b64fc7d81fcf97ac303cc1dbdd33d4.1601467849.git.mchehab+huawei@kernel.org>
 <20200930162144.GA9698@sol.localdomain>
 <20200930185333.66dacbc6@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200930185333.66dacbc6@coco.lan>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Sep 30, 2020 at 06:53:33PM +0200, Mauro Carvalho Chehab wrote:
> Hi Eric,
> 
> Em Wed, 30 Sep 2020 09:21:44 -0700
> Eric Biggers <ebiggers@kernel.org> escreveu:
> 
> > On Wed, Sep 30, 2020 at 03:24:58PM +0200, Mauro Carvalho Chehab wrote:
> > > The :c:type: tag has problems with Sphinx 3.x, as structs
> > > there should be declared with c:struct.
> > > 
> > > So, remove them, relying at automarkup.py extension to
> > > convert them into cross-references.
> > > 
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>  
> > 
> > What does this patch series apply to?  Cover letter says next-20200922, but it
> > doesn't apply.
> > 
> > It's very difficult to review patches without any way to apply them.
> 
> I double checked: it is against next-20200922. The reason of
> not being today's next is that I didn't want any new warnings
> to be introduced before I finish this patch series.
> 
> Anyway, I'm planning to do a rebase tomorrow on the top of the 
> latest -next.
> 

Doesn't work.  Here's what I did:

e@sol ~/linux $ git checkout -f next-20200922
Updating files: 100% (9850/9850), done.
HEAD is now at e64997027d5f Add linux-next specific files for 20200922

e@sol ~/linux $ b4 am 689d790237b64fc7d81fcf97ac303cc1dbdd33d4.1601467849.git.mchehab+huawei@kernel.org
Looking up https://lore.kernel.org/linux-fscrypt/689d790237b64fc7d81fcf97ac303cc1dbdd33d4.1601467849.git.mchehab%2Bhuawei%40kernel.org
Grabbing thread from lore.kernel.org/linux-fscrypt
Analyzing 7 messages in the thread
---
Thread incomplete, attempting to backfill
Grabbing thread from lore.kernel.org/linux-doc
Loaded 59 messages from https://lore.kernel.org/linux-doc/
Grabbing thread from lore.kernel.org/alsa-devel
Grabbing thread from lore.kernel.org/linux-fpga
Grabbing thread from lore.kernel.org/lkml
Loaded 2 messages from https://lore.kernel.org/lkml/
Successfully backfilled missing patches
---
Writing ./v4_20200930_mchehab_huawei_fix_html_build_with_sphinx_3_1_and_above.mbx
  [PATCH v4 01/52] docs: cdomain.py: add support for a new Sphinx 3.1+ tag
  [PATCH v4 02/52] docs: cdomain.py: extend it to handle new Sphinx 3.x tags
  [PATCH v4 03/52] docs: conf.py: disable automarkup for Sphinx 3.x
  [PATCH v4 04/52] scripts: kernel-doc: make it more compatible with Sphinx 3.x
  [PATCH v4 05/52] scripts: kernel-doc: use a less pedantic markup for funcs on Sphinx 3.x
  [PATCH v4 06/52] scripts: kernel-doc: fix troubles with line counts
  [PATCH v4 07/52] scripts: kernel-doc: reimplement -nofunction argument
  [PATCH v4 08/52] scripts: kernel-doc: fix typedef identification
  [PATCH v4 09/52] scripts: kernel-doc: don't mangle with parameter list
  [PATCH v4 10/52] docs: kerneldoc.py: append the name of the parsed doc file
  [PATCH v4 11/52] docs: kerneldoc.py: add support for kerneldoc -nosymbol
  [PATCH v4 12/52] media: docs: make CEC documents compatible with Sphinx 3.1+
  [PATCH v4 13/52] media: docs: make V4L documents more compatible with Sphinx 3.1+
  [PATCH v4 14/52] media: docs: make DVB documents more compatible with Sphinx 3.1+
  [PATCH v4 15/52] media: docs: make MC documents more compatible with Sphinx 3.1+
  [PATCH v4 16/52] media: docs: make RC documents more compatible with Sphinx 3.1+
  [PATCH v4 17/52] media: cec-core.rst: don't use c:type for structs
  [PATCH v4 18/52] math64.h: kernel-docs: Convert some markups into normal comments
    + Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
  [PATCH v4 19/52] memblock: get rid of a :c:type leftover
  [PATCH v4 20/52] drm: drm_dsc.h: fix a kernel-doc markup
  [PATCH v4 21/52] docs: remove some replace macros like |struct foo|
  [PATCH v4 22/52] docs: get rid of :c:type explicit declarations for structs
    + Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
    + Reviewed-by: André Almeida <andrealmeid@collabora.com>
  [PATCH v4 23/52] docs: trace-uses.rst: remove bogus c-domain tags
    + Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
  [PATCH v4 24/52] docs: it_IT: fix namespace collisions at locking.rst
  [PATCH v4 25/52] docs: net: ieee802154.rst: fix C expressions
  [PATCH v4 26/52] docs: genericirq.rst: don't document chip.c functions twice
  [PATCH v4 27/52] docs: kernel-api.rst: drop kernel/irq/manage.c kernel-doc tag
  [PATCH v4 28/52] docs: remove sound API duplication
    + Reviewed-by: Takashi Iwai <tiwai@suse.de>
  [PATCH v4 29/52] docs: basics.rst: move kernel-doc workqueue markups to workqueue.rst
  [PATCH v4 30/52] docs: scsi: target.rst: remove iSCSI transport class kernel-doc markup
  [PATCH v4 31/52] docs: device_link.rst: remove duplicated kernel-doc include
  [PATCH v4 32/52] docs: basics.rst: get rid of rcu kernel-doc macros
  [PATCH v4 33/52] docs: net: statistics.rst: remove a duplicated kernel-doc
  [PATCH v4 34/52] docs: pstore-blk.rst: fix kernel-doc tags
  [PATCH v4 35/52] docs: fs: fscrypt.rst: get rid of :c:type: tags
  [PATCH v4 36/52] docs: devices.rst: get rid of :c:type macros
  [PATCH v4 37/52] docs: sound: writing-an-alsa-driver.rst: get rid of :c:type
    + Reviewed-by: Takashi Iwai <tiwai@suse.de>
  [PATCH v4 38/52] docs: block: typec_bus.rst: get rid of :c:type
    + Reviewed-by: André Almeida <andrealmeid@collabora.com>
  [PATCH v4 39/52] docs: writing-an-alsa-driver.rst: fix some bad c:func: markups
    + Reviewed-by: Takashi Iwai <tiwai@suse.de>
  [PATCH v4 40/52] docs: fpga: replace :c:member: macros
  [PATCH v4 41/52] docs: kgdb.rst: fix :c:type: usages
  [PATCH v4 42/52] docs: libata.rst: fix a wrong usage of :c:type: tag
  [PATCH v4 43/52] docs: infrastructure.rst: don't include firmware kernel-doc
  [PATCH v4 44/52] docs: gpu: i915.rst: Fix several C duplication warnings
  [PATCH v4 45/52] docs: devices.rst: fix a C reference markup
  [PATCH v4 46/52] docs: it_IT: hacking.rst: fix a typo on a markup
  [PATCH v4 47/52] docs: mei.rst: fix a C expression markup
  [PATCH v4 48/52] docs: basics.rst: avoid duplicated C function declaration
  [PATCH v4 49/52] workqueue: fix a kernel-doc warning
    + Acked-by: Tejun Heo <tj@kernel.org>
  [PATCH v4 50/52] scripts: kernel-doc: try to use c:function if possible
  [PATCH v4 51/52] docs: conf.py: fix c:function support with Sphinx 3.x
  [PATCH v4 52/52] docs: conf.py: change the Sphinx 3.x+ text
---
Total patches: 52
---
Cover: ./v4_20200930_mchehab_huawei_fix_html_build_with_sphinx_3_1_and_above.cover
 Link: https://lore.kernel.org/r/cover.1601467849.git.mchehab+huawei@kernel.org
 Base: not found
       git am ./v4_20200930_mchehab_huawei_fix_html_build_with_sphinx_3_1_and_above.mbx

e@sol ~/linux $ git am ./v4_20200930_mchehab_huawei_fix_html_build_with_sphinx_3_1_and_above.mbx
Applying: docs: cdomain.py: add support for a new Sphinx 3.1+ tag
Applying: docs: cdomain.py: extend it to handle new Sphinx 3.x tags
Applying: docs: conf.py: disable automarkup for Sphinx 3.x
Applying: scripts: kernel-doc: make it more compatible with Sphinx 3.x
Applying: scripts: kernel-doc: use a less pedantic markup for funcs on Sphinx 3.x
Applying: scripts: kernel-doc: fix troubles with line counts
Applying: scripts: kernel-doc: reimplement -nofunction argument
Applying: scripts: kernel-doc: fix typedef identification
Applying: scripts: kernel-doc: don't mangle with parameter list
Applying: docs: kerneldoc.py: append the name of the parsed doc file
Applying: docs: kerneldoc.py: add support for kerneldoc -nosymbol
Applying: media: docs: make CEC documents compatible with Sphinx 3.1+
Applying: media: docs: make V4L documents more compatible with Sphinx 3.1+
error: patch failed: Documentation/userspace-api/media/v4l/hist-v4l2.rst:202
error: Documentation/userspace-api/media/v4l/hist-v4l2.rst: patch does not apply
error: patch failed: Documentation/userspace-api/media/v4l/vidioc-enum-fmt.rst:227
error: Documentation/userspace-api/media/v4l/vidioc-enum-fmt.rst: patch does not apply
Patch failed at 0013 media: docs: make V4L documents more compatible with Sphinx 3.1+
hint: Use 'git am --show-current-patch=diff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A166100B35
	for <lists+linux-fscrypt@lfdr.de>; Mon, 18 Nov 2019 19:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfKRSOD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 18 Nov 2019 13:14:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:52464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbfKRSOD (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 18 Nov 2019 13:14:03 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9E65222A4;
        Mon, 18 Nov 2019 18:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574100842;
        bh=WZxqlzttko/t7K47E27WckLwF631L0ReSZl1x8L+sOY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u6vOHOV6ktxUb9heORDtsKoQ/z6ArKiQs+i7bmlG2wQA2tzuuSGHRDOKvq391UoSY
         9BViUuNg+zIzMk3bFb7ar9tx5vhYOp34EEJ9k4nxuwKAyq5YH0xCJdTAB1PdlvdeFb
         v15IUmEsJZms5J6GntPM7NXh22mmkl/j8bBeyK0w=
Date:   Mon, 18 Nov 2019 10:14:00 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-fscrypt@vger.kernel.org, "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Paul Crowley <paulcrowley@google.com>,
        Paul Lawrence <paullawrence@google.com>,
        keyrings@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, David Howells <dhowells@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Ondrej Kozina <okozina@redhat.com>
Subject: Re: [PATCH] fscrypt: support passing a keyring key to
 FS_IOC_ADD_ENCRYPTION_KEY
Message-ID: <20191118181359.GA184560@gmail.com>
References: <20191107001259.115018-1-ebiggers@kernel.org>
 <20191115172832.GA21300@linux.intel.com>
 <20191115192227.GA150987@sol.localdomain>
 <20191115225319.GB29389@linux.intel.com>
 <20191115230430.GA217050@gmail.com>
 <20191118180102.GB5984@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118180102.GB5984@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Nov 18, 2019 at 08:01:02PM +0200, Jarkko Sakkinen wrote:
> On Fri, Nov 15, 2019 at 03:04:31PM -0800, Eric Biggers wrote:
> > On Sat, Nov 16, 2019 at 12:53:19AM +0200, Jarkko Sakkinen wrote:
> > > 
> > > > I'm working on an xfstest for this:
> > > > 
> > > > 	https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfstests-dev.git/commit/?h=fscrypt-provisioning&id=24ab6abb7cf6a80be44b7c72b73f0519ccaa5a97
> > > > 
> > > > It's not quite ready, though.  I'll post it for review when it is.
> > > > 
> > > > Someone is also planning to update Android userspace to use this.  So if there
> > > > are any issues from that, I'll hear about it.
> > > 
> > > Cool. Can you combine this patch and matching test (once it is done) to
> > > a patch set?
> > > 
> > 
> > xfstests is developed separately from the kernel (different git repo and
> > maintainer), so combining kernel and xfstests patches into the same patchset
> > doesn't make sense.  I can certainly send them out at the same time, though.
> 
> Is there instructions somewhere how to build and run these tests?
> 
> For me it is sufficient if you point a branch and have some kind
> of instructions somewhere.
> 

There are many ways to run xfstests, but I usually use kvm-xfstests.  See the
command to run the encryption tests here:

https://www.kernel.org/doc/html/latest/filesystems/fscrypt.html#tests

More details about kvm-xfstests are here:

https://github.com/tytso/xfstests-bld/blob/master/Documentation/kvm-quickstart.md
https://github.com/tytso/xfstests-bld/blob/master/Documentation/kvm-xfstests.md

But if you want to run tests which aren't included in the prebuilt kvm-xfstests
test appliance yet (such as the test for this patch), it's not quite as
straightforward since you'll also need to build your own test appliance:

https://github.com/tytso/xfstests-bld/blob/master/Documentation/building-rootfs.md

Also note that this test will require both xfstests and xfsprogs updates:

https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfstests-dev.git/log/?h=fscrypt-provisioning
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfsprogs-dev.git/log/?h=fscrypt-provisioning

- Eric

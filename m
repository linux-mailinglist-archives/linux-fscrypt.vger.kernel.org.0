Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78896100B70
	for <lists+linux-fscrypt@lfdr.de>; Mon, 18 Nov 2019 19:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfKRS14 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 18 Nov 2019 13:27:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:60694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726322AbfKRS14 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 18 Nov 2019 13:27:56 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 523B1222BF;
        Mon, 18 Nov 2019 18:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574101675;
        bh=hgVt0ngLY4LQROiy5izRjuCjb237dxfSwA55PVeCtzM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l114SmjFfMiCK5ArBiu50w/LTL4XSqt3bVoIVKzINA/oG9Eh2EGM4xiS+QA/Fgv+J
         mNypcXQpHUUYB5tY0Rr45k0ckpA44+9bEcKlJjm9DuvrhibzFR2abrr8mhumozpFnk
         s8EdB/fhR/Pqz8BjKwXm8lcS9QbxbklPvJUw0TD0=
Date:   Mon, 18 Nov 2019 10:27:53 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>, g@linux.intel.com,
        linux-fscrypt@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Paul Crowley <paulcrowley@google.com>,
        Paul Lawrence <paullawrence@google.com>,
        keyrings@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, David Howells <dhowells@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Ondrej Kozina <okozina@redhat.com>
Subject: Re: [PATCH] fscrypt: support passing a keyring key to
 FS_IOC_ADD_ENCRYPTION_KEY
Message-ID: <20191118182752.GB184560@gmail.com>
References: <20191107001259.115018-1-ebiggers@kernel.org>
 <20191115172832.GA21300@linux.intel.com>
 <20191115192227.GA150987@sol.localdomain>
 <20191115225319.GB29389@linux.intel.com>
 <20191116000139.GB18146@mit.edu>
 <20191118180222.GC5984@linux.intel.com>
 <20191118180516.GD5984@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118180516.GD5984@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Nov 18, 2019 at 08:05:16PM +0200, Jarkko Sakkinen wrote:
> On Mon, Nov 18, 2019 at 08:02:22PM +0200, Jarkko Sakkinen wrote:
> > On Fri, Nov 15, 2019 at 07:01:39PM -0500, Theodore Y. Ts'o wrote:
> > > On Sat, Nov 16, 2019 at 12:53:19AM +0200, Jarkko Sakkinen wrote:
> > > > > I'm working on an xfstest for this:
> > > > > 
> > > > > 	https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfstests-dev.git/commit/?h=fscrypt-provisioning&id=24ab6abb7cf6a80be44b7c72b73f0519ccaa5a97
> > > > > 
> > > > > It's not quite ready, though.  I'll post it for review when it is.
> > > > > 
> > > > > Someone is also planning to update Android userspace to use this.  So if there
> > > > > are any issues from that, I'll hear about it.
> > > > 
> > > > Cool. Can you combine this patch and matching test (once it is done) to
> > > > a patch set?
> > > 
> > > That's generally not done since the test goes to a different repo
> > > (xfstests.git) which has a different review process from the kernel
> > > change.
> > 
> > OK, sorry, both fscrypt and xfstests are both somewhat alien to me. That
> > is why I'm looking into setting up test environment so that I can review
> > these patches with a sane judgement.
> 
> And also since I've just barely started to help David on co-maintaining
> keyring it is better to put extra emphasis on testing even for the most
> trivial patches. That is fastest way to learn different interactions.
> 

I gave some tips about kvm-xfstests in my other reply:
https://lkml.kernel.org/linux-fscrypt/20191118181359.GA184560@gmail.com/

However, please note that xfstests is really about filesystem testing (including
fscrypt), not about testing the keyrings subsystem itself.  So while you're
certainly welcome to run the fscrypt tests, for most patches you'll encounter as
a keyrings maintainer the keyutils testsuite will be more useful.

- Eric

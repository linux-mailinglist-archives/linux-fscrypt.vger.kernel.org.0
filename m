Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9879CFE864
	for <lists+linux-fscrypt@lfdr.de>; Sat, 16 Nov 2019 00:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfKOXEd (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 Nov 2019 18:04:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:37122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726984AbfKOXEd (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 Nov 2019 18:04:33 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D6BD206D6;
        Fri, 15 Nov 2019 23:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573859073;
        bh=nxGyncx9ocQNd0mwb5/JHfFenJwa+LxTO/zcASHHirU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UcmHWP96PV3X+9Z8lt/hRwUwOl1NvZ1sHgtSW8m35ozmeWnMRBMIR4qTYi7vl3nRG
         CcvfsfzewHxFXDROgORR2myIWoZySz7VrbqAAvv75gLUfc5HMkmqLw2snJ6hWwzP3c
         AGGdixiWm0BZjeY5KVrn+ndhBxOpU4+XC9y0rzz4=
Date:   Fri, 15 Nov 2019 15:04:31 -0800
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
Message-ID: <20191115230430.GA217050@gmail.com>
References: <20191107001259.115018-1-ebiggers@kernel.org>
 <20191115172832.GA21300@linux.intel.com>
 <20191115192227.GA150987@sol.localdomain>
 <20191115225319.GB29389@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115225319.GB29389@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Nov 16, 2019 at 12:53:19AM +0200, Jarkko Sakkinen wrote:
> 
> > I'm working on an xfstest for this:
> > 
> > 	https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfstests-dev.git/commit/?h=fscrypt-provisioning&id=24ab6abb7cf6a80be44b7c72b73f0519ccaa5a97
> > 
> > It's not quite ready, though.  I'll post it for review when it is.
> > 
> > Someone is also planning to update Android userspace to use this.  So if there
> > are any issues from that, I'll hear about it.
> 
> Cool. Can you combine this patch and matching test (once it is done) to
> a patch set?
> 

xfstests is developed separately from the kernel (different git repo and
maintainer), so combining kernel and xfstests patches into the same patchset
doesn't make sense.  I can certainly send them out at the same time, though.

- Eric

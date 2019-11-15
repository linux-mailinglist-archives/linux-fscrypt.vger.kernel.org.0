Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD1AFE582
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Nov 2019 20:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfKOTWa (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 Nov 2019 14:22:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:34062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726308AbfKOTWa (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 Nov 2019 14:22:30 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36094206D9;
        Fri, 15 Nov 2019 19:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573845749;
        bh=upuiRVOg48zBrOcDo8mSF+x02Zd4aynU2rKOYkmP0Ug=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bjZdfDwhBnWRxGaakLSBtRR3lNyx9RSw1w8Q+az70jtKCUxDBYcteMj6kM7uw1+BJ
         mT5QmqPPX5h41lBPcVfK/APGOyYDw5helVm2UUL7TRYd0VcOKDXrzEOKHmiyfg5EGU
         WfIiJ5bxXeb0nzFxv6xnpeSLrmHLYQl8Nq/0zAJ4=
Date:   Fri, 15 Nov 2019 11:22:27 -0800
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
Message-ID: <20191115192227.GA150987@sol.localdomain>
References: <20191107001259.115018-1-ebiggers@kernel.org>
 <20191115172832.GA21300@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115172832.GA21300@linux.intel.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Nov 15, 2019 at 07:28:53PM +0200, Jarkko Sakkinen wrote:
> 
> I don't see anything obviously wrong. Just would reformat it a bit.
> How you tested it?
> 

I'm not sure all the blank lines you're suggesting would be an improvement.
The ones in fscrypt_provisioning_key_preparse() might make sense though.

I'm working on an xfstest for this:

	https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfstests-dev.git/commit/?h=fscrypt-provisioning&id=24ab6abb7cf6a80be44b7c72b73f0519ccaa5a97

It's not quite ready, though.  I'll post it for review when it is.

Someone is also planning to update Android userspace to use this.  So if there
are any issues from that, I'll hear about it.

- Eric

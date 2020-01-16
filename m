Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECE7813FA08
	for <lists+linux-fscrypt@lfdr.de>; Thu, 16 Jan 2020 20:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbgAPTxS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 16 Jan 2020 14:53:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:48480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729397AbgAPTxR (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 16 Jan 2020 14:53:17 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0831D2072B;
        Thu, 16 Jan 2020 19:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579204397;
        bh=wJo6G4Os3vUaz+L/FQRKvyrd+41zoPbKXPdrMqimves=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qp3Ii9MYGWpV8iR7Gv2oPdUFtO2EvG4oORVStFxGN9fhhrezobZGAPOGVV872L8CN
         0Hjl1BRaP+aExZJca9NlSjPcgkUHYh6IPATbVfzrfd5V2wpjr8IH062RxoY6FF8qzn
         mlciFnE58/cetsQdnD9VTRVwxLXCyrQwIQr218Dg=
Date:   Thu, 16 Jan 2020 11:53:15 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-fscrypt@vger.kernel.org, Sergey Anpilov <anpilov@fb.com>,
        Pavlo Kushnir <pavlo@fb.com>
Subject: Re: Using TPM trusted keys (w/ v2 policies?)
Message-ID: <20200116195314.GB235100@gmail.com>
References: <20200116193228.GA266386@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116193228.GA266386@vader>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jan 16, 2020 at 11:32:28AM -0800, Omar Sandoval wrote:
> Hi,
> 
> We're exploring fscrypt, and we were hoping to make use of a trusted key [1] so
> that we could avoid exposing the master key to userspace. I found a patch [2]
> from a couple of years ago adding this support. However, trusted keys in the
> kernel seem to be tied to the keyring, which is not used for v2 encryption
> policies. Seeing as v1 policies are considered deprecated, what would be the
> way to move forward with this feature? Would it make sense to add minimal
> keyring integration for v2 policies in order to support this use case?
> 
> Thanks!
> 
> 1: https://www.kernel.org/doc/html/latest/security/keys/trusted-encrypted.html
> 2: https://lore.kernel.org/linux-fscrypt/20180118131359.8365-1-git@andred.net/

There's already a patch that will be going into 5.6 that adds support for
passing a keyring key to FS_IOC_ADD_ENCRYPTION_KEY
(https://lkml.kernel.org/linux-fscrypt/20191119222447.226853-1-ebiggers@kernel.org/).

But it only supports a new key type "fscrypt-provisioning" whose payload
contains the raw key.  If you wanted "trusted" key support, you'd need to add
it, probably as a new flag to FS_IOC_ADD_ENCRYPTION_KEY which indicates that the
key specified by key_id is of type "trusted".

Note that there are some major limitations to what you are trying to do.  First,
the raw key of "trusted" keys is still present in the clear in kernel memory.
Depending on your security architecture, this may not be any better than having
it be present in a root-owned userspace process.  Second, since the "trusted"
key type is not tied to a specific kernel subsystem or use, userspace could
request that the same key be used for different purposes, which could leak
information about the key to userspace.  (This is why we used a custom key type
"fscrypt-provisioning" for the new API rather than reusing "logon".)

There's also someone working on actual hardware-wrapped keys, where the key used
to encrypt file contents is never exposed to software at all
(https://android-review.googlesource.com/c/kernel/common/+/1200864/25).  In my
opinion, doing TPM unsealing in the kernel is sort of a weird intermediate
state, which isn't necessarily any better than just TPM unsealing in userspace.
So if you need this feature it's going to be up to you to write the patch and
argue that it's actually useful.

- Eric

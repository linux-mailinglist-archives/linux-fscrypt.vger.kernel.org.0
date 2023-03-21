Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE8BD6C2763
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Mar 2023 02:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjCUBW7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 Mar 2023 21:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCUBW7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 Mar 2023 21:22:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11766CC24
        for <linux-fscrypt@vger.kernel.org>; Mon, 20 Mar 2023 18:22:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAFE3618CD
        for <linux-fscrypt@vger.kernel.org>; Tue, 21 Mar 2023 01:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B59FC433D2;
        Tue, 21 Mar 2023 01:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679361695;
        bh=0tIux3ZYzc+EuRP80bD46ng0la9wLEyKCU2G86naTAE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hVfhSxgcJlWeBtX86TNqjsNa3NaBf10bNMibvV0JVwy63wM0KUlpyNY+q49bhC848
         AElooO8T58Cofio+OunDxfssAQVjyYdLsHLUvb1JJM6jfz1a3kVTNDzTrqQQz/PzUk
         XwVHxoaNGGvnmj0ibj2sMZa4uriLOfsFHXOEp2FU3VwjNR6Rg2RQwwTIr4/KcWn4J3
         hO/zem2Szurso4O21gODnyZD6BEZeGGKgjvBBGdDfUhoAL9iz1qcR2THXHSOpaCBJr
         1u53m9S8xAtI/LFzP3ZK+aW59iqz4fJebqzu7fF2kDQZQCpZ8oret/a3BR5Im2WfH2
         96O6AtgS/k1iw==
Date:   Tue, 21 Mar 2023 01:21:23 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Luis Henriques <lhenriques@suse.de>, linux-fscrypt@vger.kernel.org
Subject: Re: Is there any userland implementations of fscrypt
Message-ID: <ZBkGk+utJGHbgfj/@gmail.com>
References: <ffa49a00-4b3f-eeb3-6db8-11509fd08c9b@redhat.com>
 <20230320211908.GC1434@sol.localdomain>
 <4a910d6c-3642-6df1-8600-c6ae587a4282@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4a910d6c-3642-6df1-8600-c6ae587a4282@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Mar 21, 2023 at 09:03:02AM +0800, Xiubo Li wrote:
> On 21/03/2023 05:19, Eric Biggers wrote:
> > [+Cc linux-fscrypt]
> > 
> > On Mon, Mar 20, 2023 at 06:49:29PM +0800, Xiubo Li wrote:
> > > Hi Eric,
> > > 
> > > BTW, I am planing to support the fscrypt in userspace ceph client. Is there
> > > any userland implementation of fscrypt ? If no then what should I use
> > > instead ?
> > > 
> > I assume that you mean userspace code that encrypts files the same way the
> > kernel does?
> 
> Yeah, a library just likes the fs/crypto/ in kernel space.
> 
> I found the libkcapi, Linux Kernel Crypto API User Space Interface
> Library(http://www.chronox.de/libkcapi.html)  seems exposing the APIs from
> crypto/ not the fs/crypto/.

Much of fs/crypto/ is tightly coupled to how the Linux kernel implements
filesystems, so I'm not sure what you are expecting exactly!  The actual
cryptography can definitely be replicated in userspace, though.

> > There's some code in xfstests that reproduces all the fscrypt encryption for
> > testing purposes
> > (https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/tree/src/fscrypt-crypt-util.c?h=for-next).
> > It does *not* use production-quality implementations of the algorithms, though.
> > It just has minimal implementations for testing without depending on OpenSSL.
> 
> This is performed in software.
> 
> > Similar testing code can also be found in Android's vts_kernel_encryption_test
> > (https://android.googlesource.com/platform/test/vts-testcase/kernel/+/refs/heads/master/encryption).
> > It uses BoringSSL for the algorithms when possible, but unlike the xfstest it
> > does not test filenames encryption.
> 
> This too.

So you are looking for something that is *not* performed in software?  What do
you mean by that, exactly?  Are you looking to use an off-CPU hardware crypto
accelerator?  The Linux kernel exposes those to userspace through AF_ALG.
Though, it's worth noting that that style of crypto acceleration has fallen a
bit out of favor these days, as modern CPUs have crypto instructions built-in.

> > There's also some code in mkfs.ubifs in mtd-utils
> > (http://git.infradead.org/mtd-utils.git) that supports creating encrypted files.
> > However, it's outdated since it only supports policy version 1.
> > 
> > Which algorithms do you need to support?  The HKDF-SHA512 + AES-256-XTS +
> > AES-256-CTS combo shouldn't be hard to support if your program can depend on
> > OpenSSL (1.1.0 or later).
> 
> Yeah, ceph has already depended on the OpenSSL.
> 
> I think the OpenSSL will be the best choice for now.

That seems like the right choice.  Note that that is "software" too, but I think
that's what you want!

- Eric

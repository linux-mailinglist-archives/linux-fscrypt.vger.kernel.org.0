Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE02A6C2379
	for <lists+linux-fscrypt@lfdr.de>; Mon, 20 Mar 2023 22:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbjCTVTQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 Mar 2023 17:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjCTVTP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 Mar 2023 17:19:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD00446AB
        for <linux-fscrypt@vger.kernel.org>; Mon, 20 Mar 2023 14:19:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A4F8B810BC
        for <linux-fscrypt@vger.kernel.org>; Mon, 20 Mar 2023 21:19:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143C9C433EF;
        Mon, 20 Mar 2023 21:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679347150;
        bh=tcWlnSoh1TQlDCcOs3Vi6XfvBQET3YA71U1XCFk8XTw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TMv6MiWa7TP79Wkvu1egRdaceER56LaHKyZQX4ez18FprkxRbRvkF4JIf7tiO+wzZ
         hUkbCrCiyhC3VAfSSnnk6lqlDeNroQtipfNjJvrMU8kB13Lnu+ry02yRGhFx6afdZt
         rsNhjk5rQfEpd3tORogvwpb/kLWAksRchTh0UOQDlf2xsyf3gMtKgsVB6FxPwQxy6l
         ggRrtJ6D1+yrP7T6/hSiaQVknogX5y1fogX3x04yvfdMBfztNRMjzmLBnSpCfBgcUs
         s5J6Jf9bdf7M45Bt1fhrUfdoq/whbIl891ZdHo1vF0hXR9atgk7HENlMpSZt2+CUkP
         iYxL3qxMQlBGQ==
Date:   Mon, 20 Mar 2023 14:19:08 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Luis Henriques <lhenriques@suse.de>, linux-fscrypt@vger.kernel.org
Subject: Re: Is there any userland implementations of fscrypt
Message-ID: <20230320211908.GC1434@sol.localdomain>
References: <ffa49a00-4b3f-eeb3-6db8-11509fd08c9b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffa49a00-4b3f-eeb3-6db8-11509fd08c9b@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

[+Cc linux-fscrypt]

On Mon, Mar 20, 2023 at 06:49:29PM +0800, Xiubo Li wrote:
> Hi Eric,
> 
> BTW, I am planing to support the fscrypt in userspace ceph client. Is there
> any userland implementation of fscrypt ? If no then what should I use
> instead ?
> 

I assume that you mean userspace code that encrypts files the same way the
kernel does?

There's some code in xfstests that reproduces all the fscrypt encryption for
testing purposes
(https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/tree/src/fscrypt-crypt-util.c?h=for-next).
It does *not* use production-quality implementations of the algorithms, though.
It just has minimal implementations for testing without depending on OpenSSL.

Similar testing code can also be found in Android's vts_kernel_encryption_test
(https://android.googlesource.com/platform/test/vts-testcase/kernel/+/refs/heads/master/encryption).
It uses BoringSSL for the algorithms when possible, but unlike the xfstest it
does not test filenames encryption.

There's also some code in mkfs.ubifs in mtd-utils
(http://git.infradead.org/mtd-utils.git) that supports creating encrypted files.
However, it's outdated since it only supports policy version 1.

Which algorithms do you need to support?  The HKDF-SHA512 + AES-256-XTS +
AES-256-CTS combo shouldn't be hard to support if your program can depend on
OpenSSL (1.1.0 or later).

- Eric

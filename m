Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10A7B64F2C8
	for <lists+linux-fscrypt@lfdr.de>; Fri, 16 Dec 2022 21:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbiLPUzZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 16 Dec 2022 15:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiLPUzW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 16 Dec 2022 15:55:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A8F57B6B;
        Fri, 16 Dec 2022 12:55:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B1D562203;
        Fri, 16 Dec 2022 20:55:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72201C433F0;
        Fri, 16 Dec 2022 20:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671224120;
        bh=Xwcytn+LoirjjEGfFRYRfniLWhHW1mgnIB+bcrZQfrA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M08Tp1Nd4FaewBLlMg7sBZRj6HV+oopMEURtYwNlMRbz4VjYPGQ/qCd+W7pemHb9x
         0vUAuy1Cm5dVMIp7PhWEbp3itnRVeJ8KeYxDynKo1QWtmJpOOpqen99iyVERF4PyCy
         oJBXgXdmZPg3XQxLDaOp/X/scQDEVUl2ugeJiVkCVxSWEW1BvHV2yI/r6mFjbA+fG/
         plymEurGnXR0A74q+mivvOnbm7dVuUbtTHVGlbx8uzOuB2diLWpC1T6gWiLeor9b2i
         ytVWVHlC5efZgfm3nV1xYO9dH6BFQe8jnpcK75vuWSIFj9v42UjwXXru4GKqdoIA9h
         xkNZ64Qu9aIsQ==
Date:   Fri, 16 Dec 2022 12:55:18 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Luca Boccassi <bluca@debian.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-integrity@vger.kernel.org,
        Jes Sorensen <jsorensen@meta.com>,
        Victor Hsieh <victorhsieh@google.com>
Subject: Re: [PATCH] fsverity: mark builtin signatures as deprecated
Message-ID: <Y5zbNtaadNGPGHQb@sol.localdomain>
References: <20221208033548.122704-1-ebiggers@kernel.org>
 <eea9b4dc9314da2de39b4181a4dac59fda8b0754.camel@debian.org>
 <Y5JPRW+9dt28JpZ7@sol.localdomain>
 <00c7b6b0e2533b2bf007311c2ede64cb92a130db.camel@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00c7b6b0e2533b2bf007311c2ede64cb92a130db.camel@debian.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 08, 2022 at 09:37:29PM +0000, Luca Boccassi wrote:
> 
> The second question is easy: because the kernel is the right place for
> our use case to do this verification and enforcement, exactly like dm-
> verity does.

Well, dm-verity's in-kernel signature verification support is a fairly new
feature.  Most users of dm-verity don't use it, and will not be using it.

> Userspace is largely untrusted, or much lower trust anyway.

Yes, which means the kernel is highly trusted.  Which is why parsing complex
binary formats, X.509 and PKCS#7, in C code in the kernel is not a great idea...

- Eric

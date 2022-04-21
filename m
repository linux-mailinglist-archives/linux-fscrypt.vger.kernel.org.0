Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E7950A857
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 Apr 2022 20:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391518AbiDUStO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 Apr 2022 14:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391521AbiDUStL (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 Apr 2022 14:49:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A494BFF2;
        Thu, 21 Apr 2022 11:46:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64CF6B828C0;
        Thu, 21 Apr 2022 18:46:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5EEC385A1;
        Thu, 21 Apr 2022 18:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650566779;
        bh=xIFSZuODUQ/i7IO02KTWGkjbD5hF9Q1d08rVSQEHXn0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mk+bBkEvbPEQTisY2L/fxw/dTRah48WE//hutSJZHR4isII1JrO0/6vZwoO6MW3us
         9yhuj27ur4Nt6Lf70LGT6JiDsANR1RSXxV5GXb65wf/oPMbiqfcFSWQE/UBxnDESeN
         EHD8crMvmEiFFluUPIKwP1IJi6k65Sj4qXOhaYBEi8zUVqb7zid8TbVflUKQcnLbgK
         WNdO5OF0F57RQ1o43XEkFHqwrF5GSPEVEZAiMGjpWhNJEnPQ+47n31/7MzUFzTzaJ2
         Yt1qAaEJoggASrGlzLJle2kOQNHDGmYh7F31NWhxHVtmISzLXOoaGUfg1WJyMtSbDo
         mSP0IrdOaICsA==
Date:   Thu, 21 Apr 2022 11:46:17 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH] fscrypt: log when starting to use inline encryption
Message-ID: <YmGmeZ5sm9nqEqxd@sol.localdomain>
References: <20220414053415.158986-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414053415.158986-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Apr 13, 2022 at 10:34:15PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When inline encryption is used, the usual message "fscrypt: AES-256-XTS
> using implementation <impl>" doesn't appear in the kernel log.  Add a
> similar message for the blk-crypto case that indicates that inline
> encryption was used, and whether blk-crypto-fallback was used or not.
> This can be useful for debugging performance problems.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/crypto/fscrypt_private.h |  4 +++-
>  fs/crypto/inline_crypt.c    | 33 ++++++++++++++++++++++++++++++++-
>  fs/crypto/keysetup.c        |  2 +-
>  3 files changed, 36 insertions(+), 3 deletions(-)

Applied to fscrypt.git#master for 5.19.

- Eric

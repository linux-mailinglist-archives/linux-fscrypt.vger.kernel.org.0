Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95F1350056A
	for <lists+linux-fscrypt@lfdr.de>; Thu, 14 Apr 2022 07:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237923AbiDNFeA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 14 Apr 2022 01:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbiDNFd7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 14 Apr 2022 01:33:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4923A18B;
        Wed, 13 Apr 2022 22:31:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A977561E32;
        Thu, 14 Apr 2022 05:31:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E90C385A1;
        Thu, 14 Apr 2022 05:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649914295;
        bh=L5WfTzpjmjPzbWBOyi36W4xnedgDh3ktWaS0CuxYK2A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gRf6aEfGzR7cjx2ARWlkHDkLhiYl21dZDhTgSJtG1yCo6JAZZQoZ3VD0ckT/44hy0
         IBgRPNsmLZf1C1+ya4UCWyPlFjo9/iWkLxeOYhvlrYhDPeGhgs6SKlm0TvUSnLM6tZ
         5htpQJu+7Ep7a2Mj0Ja+ZM+avjLOV41Ggqdd4SZFwbYDY4mXNVVVCTNNTNQ2UPAwDK
         ilCpygqNTadPdfUW6h8nbVonntqOeyYLI5YMaAXba7ghSpOk2x0Mkc2hpXxihFLZMg
         g8YAgbyBFpBPzblXAtfGGzy9pinnedmIJ/wjZ5Wq11DwNYN5BANzlUaLM41cX5G5X6
         GpystR7vfkPjA==
Date:   Wed, 13 Apr 2022 22:31:33 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH] fscrypt: split up FS_CRYPTO_BLOCK_SIZE
Message-ID: <YlextfUbirO97Gl7@sol.localdomain>
References: <20220405010914.18519-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405010914.18519-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,SUSPICIOUS_RECIPS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Apr 04, 2022 at 06:09:14PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> FS_CRYPTO_BLOCK_SIZE is neither the filesystem block size nor the
> granularity of encryption.  Rather, it defines two logically separate
> constraints that both arise from the block size of the AES cipher:
> 
> - The alignment required for the lengths of file contents blocks
> - The minimum input/output length for the filenames encryption modes
> 
> Since there are way too many things called the "block size", and the
> connection with the AES block size is not easily understood, split
> FS_CRYPTO_BLOCK_SIZE into two constants FSCRYPT_CONTENTS_ALIGNMENT and
> FSCRYPT_FNAME_MIN_MSG_LEN that more clearly describe what they are.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/crypto/crypto.c      | 10 +++++-----
>  fs/crypto/fname.c       | 11 +++++++++--
>  fs/ubifs/ubifs.h        |  2 +-
>  include/linux/fscrypt.h | 12 +++++++++++-
>  4 files changed, 26 insertions(+), 9 deletions(-)

Applied to fscrypt.git#master for 5.19.

- Eric

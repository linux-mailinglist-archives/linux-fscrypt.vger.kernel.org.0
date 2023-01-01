Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477CE65AA20
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 Jan 2023 14:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbjAANbY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 Jan 2023 08:31:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjAANbX (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 Jan 2023 08:31:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06883885
        for <linux-fscrypt@vger.kernel.org>; Sun,  1 Jan 2023 05:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672579839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PfyKh+6ly8mcavFLlVRXy4fl8nsb5VprOU1Yhje8hko=;
        b=izhNnQHRE7KlYb7hftRtHtqk8eK0bzvsK24OAp+mSSaazQLEPB/Thc0cvx2P+isjV3XfUO
        uZERU8Y/1sswZG5NhSRFuFsiLKvsxdJeDrG12LEKxYpYM+6e03fpq/N19K7J5o3bU1paWM
        dJ2QJSnBICRXjx6jeg9M0dj9u6W03ck=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-241-Zq6rxK0ROT6KhrGo_mLJvA-1; Sun, 01 Jan 2023 08:30:38 -0500
X-MC-Unique: Zq6rxK0ROT6KhrGo_mLJvA-1
Received: by mail-pf1-f198.google.com with SMTP id 24-20020aa79118000000b00580476432deso12245912pfh.23
        for <linux-fscrypt@vger.kernel.org>; Sun, 01 Jan 2023 05:30:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PfyKh+6ly8mcavFLlVRXy4fl8nsb5VprOU1Yhje8hko=;
        b=Lf7+VQeoGB3mhUUGFJrX4SbVqH8K6H9vKdNqSR3FdJjrEugt/K/ueqpbLHk/aXISZQ
         ElvjwtR84y1GU5k6wYg7Bu8s1yI4UtSmeVaiADR2Q/O9NGTq4ru3iZSnN4iSwJ3fYKVB
         3sRwUh4dM2GXgzQZ30f+7qkAwYOW3jvgtX7SLf7wb0k3UYgnC+WmDlJYpDFq6ZxTfTiX
         QxgZEGUaKBVPn7rjtTgbasBper1rYw6ROhKn88eWC7aib/boCCmyMghw7Xb3uE6FDhc1
         cod1wsXQhsdTGrth2BMWQabvTp0D/D8JprnnWIKZSKpR94JJqSAZulWwP195jSEYpxrY
         48ag==
X-Gm-Message-State: AFqh2kqelPLYs6b8OHNiByXtTX637xc0WKO5YDI+YfDWmu5S+kPJawAE
        iUu03eViQfsRSELNNPUKkxuTUP91e/1Ici1AKU0osJeO2ozwgN60uWrwzY/uZtIixuf2pNB/cf4
        H4Dj7vwsm9zwjhmUVqk9vlR0BQA==
X-Received: by 2002:aa7:9147:0:b0:56c:318a:f83b with SMTP id 7-20020aa79147000000b0056c318af83bmr44952567pfi.13.1672579836906;
        Sun, 01 Jan 2023 05:30:36 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsZcU2Onik1n60YvsLbDVPYFSI38W8QIO1sdI79iDnlqKaQNWTbKI/2r0XZuH9+dgDdmHkEOA==
X-Received: by 2002:aa7:9147:0:b0:56c:318a:f83b with SMTP id 7-20020aa79147000000b0056c318af83bmr44952552pfi.13.1672579836596;
        Sun, 01 Jan 2023 05:30:36 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id z15-20020a63190f000000b0046ffe3fea77sm15361159pgl.76.2023.01.01.05.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Jan 2023 05:30:36 -0800 (PST)
Date:   Sun, 1 Jan 2023 21:30:32 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v3 00/10] xfstests: update verity tests for non-4K block
 and page size
Message-ID: <20230101133032.6jz4dvd6wx5m3ws5@zlang-mailbox>
References: <20221229233222.119630-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221229233222.119630-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 29, 2022 at 03:32:12PM -0800, Eric Biggers wrote:
> This series updates the verity xfstests to eliminate implicit
> assumptions that 'merkle_tree_block_size == fs_block_size == page_size
> == 4096', and to provide some test coverage for cases where
> merkle_tree_block_size differs from fs_block_size and/or page_size.  It
> doesn't add any new test scripts, but it does update some of the
> existing test scripts to test multiple block sizes.
> 
> This goes along with my kernel patch series
> "fsverity: support for non-4K pages"
> (https://lore.kernel.org/linux-fsdevel/20221223203638.41293-1-ebiggers@kernel.org/T/#u).
> However, it's not necessary to wait for that kernel patch series to be
> applied before applying this xfstests patch series.
> 
> Changed in v3:
>   - Fixed generic/574 failure with some bash versions.

Thanks for fixing this failure, this version looks good to me. I'd like to
merge this patchset with my RVB.

> 
> Changed in v2:
>   - Adjusted the output of generic/574, generic/575, and generic/624
>     slightly to avoid confusion.
> 
> Eric Biggers (10):
>   common/verity: add and use _fsv_can_enable()
>   common/verity: set FSV_BLOCK_SIZE to an appropriate value
>   common/verity: use FSV_BLOCK_SIZE by default
>   common/verity: add _filter_fsverity_digest()
>   generic/572: support non-4K Merkle tree block size
>   generic/573: support non-4K Merkle tree block size
>   generic/577: support non-4K Merkle tree block size
>   generic/574: test multiple Merkle tree block sizes
>   generic/624: test multiple Merkle tree block sizes
>   generic/575: test 1K Merkle tree block size
> 
>  common/verity         |  84 ++++++++++++----
>  tests/generic/572     |  21 ++--
>  tests/generic/572.out |  10 +-
>  tests/generic/573     |   8 +-
>  tests/generic/574     | 219 +++++++++++++++++++++++++-----------------
>  tests/generic/574.out |  83 +---------------
>  tests/generic/575     |  57 ++++++++---
>  tests/generic/575.out |   8 +-
>  tests/generic/577     |  24 ++---
>  tests/generic/577.out |  10 +-
>  tests/generic/624     | 119 ++++++++++++++++-------
>  tests/generic/624.out |  15 +--
>  12 files changed, 370 insertions(+), 288 deletions(-)
> 
> 
> base-commit: 3dc46f477b39d732e1841e6f5a180759cee3e8ce
> -- 
> 2.39.0
> 


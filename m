Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B73A5098FB
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 Apr 2022 09:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381330AbiDUH0z (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 Apr 2022 03:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiDUH0x (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 Apr 2022 03:26:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DF01837E;
        Thu, 21 Apr 2022 00:24:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 393A0B82297;
        Thu, 21 Apr 2022 07:24:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E52C385A1;
        Thu, 21 Apr 2022 07:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650525841;
        bh=QAbZly7uVhYF3x+1hUCE5N4c3jqhIBI0hnP70lsaq4k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KEMKmCJE0ZI6LJVRU5ugo+fqWqPGaI+fgDJvUvWevavJtX8VZrbgp5P3al77FM0j/
         LOT/upIJBl5AhM/s5OrzRtQtDGrGi7AncTb6Izwewn5WWv8HGLjEWspjBb7O0Hf+5g
         Fs3tjBXTc3FSBTDf98h52pi+LEAY5cfNWeAj+3AI9vy+ZjBhg4VGDOVp79ICtxnle2
         21Z4YaUHu+n6KPG+OHWwy7gMp1YCTaE/ulYM4iC9D1w2iWnYsq8o0+5qDgmav7aZBu
         wnR34/utUDORKrvFnrtCxnuhdzZV/fzZ8coMyVAHRlEJvcj4uNW3O71wLSrF0w8anl
         khTC28nmpGVfA==
Date:   Thu, 21 Apr 2022 00:24:00 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ritesh Harjani <ritesh.list@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Subject: Re: [RFC 0/6] ext4: Move out crypto ops to ext4_crypto.c
Message-ID: <YmEGkAQ+T/3EnVHC@sol.localdomain>
References: <cover.1650517532.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1650517532.git.ritesh.list@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Apr 21, 2022 at 10:53:16AM +0530, Ritesh Harjani wrote:
> Hello,
> 
> This is 1st in the series to cleanup ext4/super.c, since it has grown quite large.
> This moves out crypto related ops and few definitions to fs/ext4/ext4_crypto.c
> 
> Testing
> =========
> 1. Tested "-g encrypt" with default configs.
> 2. Compiled tested on x86 & Power.
> 
> 
> Ritesh Harjani (6):
>   fscrypt: Provide definition of fscrypt_set_test_dummy_encryption
>   ext4: Move ext4 crypto code to its own file ext4_crypto.c
>   ext4: Directly opencode ext4_set_test_dummy_encryption
>   ext4: Cleanup function defs from ext4.h into ext4_crypto.c
>   ext4: Move all encryption related into a common #ifdef
>   ext4: Use provided macro for checking dummy_enc_policy
> 
>  fs/ext4/Makefile        |   1 +
>  fs/ext4/ext4.h          |  81 +++--------------
>  fs/ext4/ext4_crypto.c   | 192 ++++++++++++++++++++++++++++++++++++++++
>  fs/ext4/super.c         | 158 ++++-----------------------------
>  include/linux/fscrypt.h |   7 ++
>  5 files changed, 227 insertions(+), 212 deletions(-)
>  create mode 100644 fs/ext4/ext4_crypto.c

How about calling it crypto.c instead of ext4_crypto.c?  It is already in the
ext4 directory, so ext4 is implied.

Otherwise this patchset looks good to me.

Did you consider moving any of the other CONFIG_FS_ENCRYPTION code blocks into
the new file as well?  The implementation of FS_IOC_GET_ENCRYPTION_PWSALT might
be a good candidate too.

- Eric

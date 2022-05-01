Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6F91516275
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 May 2022 09:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238810AbiEAHWH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 May 2022 03:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234593AbiEAHWG (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 May 2022 03:22:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB9C49FB9;
        Sun,  1 May 2022 00:18:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4523611D6;
        Sun,  1 May 2022 07:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02166C385AA;
        Sun,  1 May 2022 07:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651389521;
        bh=tAg0P1xG/JWQnY4z5XupJalk890R+RBNmphemw59FUs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YXlu+EHRWgBqlb0cmccW+hV6fNPJAzHjmv9tzzdutdrB7jPIiVLIr/3yazNZ87M9M
         hCjHF+sOU0AgOH3iKi8xTI/N/+ArgTwf5i4KIo4AZpJ/etpKcJW7xGHkB09YXfzRDY
         M+o9kN6HUUnOpCI0e6vvbxnxEKUZtgAh63j/9l1mqNIoJE1yDAQurvbnPy9Kbj41qL
         LlgqiMpBV2Trpsx0uQBfS480O93ovE57ja3wqxIMSSylcJUEI7WLO7tk8FkXhza587
         L5apOYspPGUOjMEoe8+aAaBnLiX8v3/toNYl91ko4/EZH2siUHYTeTkY3u9dUT4eRm
         o7abEt7408abA==
Date:   Sun, 1 May 2022 00:18:39 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ritesh Harjani <ritesh.list@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Subject: Re: [RFC 0/6] ext4: Move out crypto ops to ext4_crypto.c
Message-ID: <Ym40Tx0W8Mvk8XOg@sol.localdomain>
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

FYI, the patchset
https://lore.kernel.org/linux-ext4/20220501050857.538984-1-ebiggers@kernel.org
I just sent out cleans up how the test_dummy_encryption mount option is handled.
It would supersede patches 1, 3, 5, and 6 of this series (since those all only
deal with test_dummy_encryption-related code).

To avoid conflicting changes, maybe you should just focus on your patches 2 and
4 for now, along with possibly FS_IOC_GET_ENCRYPTION_PWSALT as I mentioned?
There shouldn't be any overlap that way.

- Eric

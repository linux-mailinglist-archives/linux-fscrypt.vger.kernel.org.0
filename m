Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB6152752E
	for <lists+linux-fscrypt@lfdr.de>; Sun, 15 May 2022 05:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234711AbiEODdu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 14 May 2022 23:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234740AbiEODds (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 14 May 2022 23:33:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DB63896;
        Sat, 14 May 2022 20:33:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 835BCB80B48;
        Sun, 15 May 2022 03:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F5DC385B8;
        Sun, 15 May 2022 03:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652585623;
        bh=FBjvRJwMMUU2E4ylmyW/0qpS3y2MEUZjZzDwycz0XHA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ayugv7rpzSCkNQ+FBPfwLO3JVrpDIF4pK8aF0wdpEYwnU8/ez6taRbxemINI2VjQg
         fXXBc54WnfR5zGXMP13DDSx5jqWD162CGtxrYuEFd9LFURVcY0AXBP0Pih671z+mE3
         U8vsM2HtiA8ScAotlC1h5sojVlOcdqr5YwyjV0q03G5rLK8qT8fVEvlTKkiuCQOkXj
         KX6A949CXDKPf2CMQnCY31t9urggLXczPhNvRjXGMNxDNSL8LmZRRQ07RpBLOvXXI+
         cQGouC9J1B0uLEOiJZHzJ5bshBTU1Qtb2HiyCkyVE5f5gP7E8A98uzT8v3kTCXS7X4
         nIAW1+47bY6Ug==
Date:   Sat, 14 May 2022 20:33:41 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ritesh Harjani <ritesh.list@gmail.com>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCHv2 1/3] ext4: Move ext4 crypto code to its own file
 crypto.c
Message-ID: <YoB0lYeJv+Cm+C5Y@sol.localdomain>
References: <cover.1652539361.git.ritesh.list@gmail.com>
 <4f6b9ff4411ced6591f858119feb025300ecf918.1652539361.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f6b9ff4411ced6591f858119feb025300ecf918.1652539361.git.ritesh.list@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, May 14, 2022 at 10:52:46PM +0530, Ritesh Harjani wrote:
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index a743b1e3b89e..9100f0ba4a52 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2731,6 +2731,9 @@ extern int ext4_fname_setup_ci_filename(struct inode *dir,
>  					 struct ext4_filename *fname);
>  #endif
>  
> +/* ext4 encryption related stuff goes here crypto.c */
> +extern const struct fscrypt_operations ext4_cryptops;
> +
>  #ifdef CONFIG_FS_ENCRYPTION

Shouldn't the declaration of ext4_cryptops go in the CONFIG_FS_ENCRYPTION block?

Otherwise this patch looks good, thanks.

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric

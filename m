Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD35E52758C
	for <lists+linux-fscrypt@lfdr.de>; Sun, 15 May 2022 06:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235529AbiEOEp6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 15 May 2022 00:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbiEOEp4 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 15 May 2022 00:45:56 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8196B48;
        Sat, 14 May 2022 21:45:54 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id h24so5849195pgh.12;
        Sat, 14 May 2022 21:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Eq/82tu6X9ZKcrAkx2wEFHmPZM+JAYtAiESTMva+DrQ=;
        b=PNC2aa/iYP8MoLEODVeDwdoemnQd9QcUgfOu8tIXnTK/3NVAe/UTpiBW7DH2zCkhu6
         JbVHLMml3YTABOdaEMmMK5ROdw0vYkQWAFP5u/DY3vttmLPvOFHqztD5FAjClfZuAers
         1z/U0j+/0itzjxWIHCwuXNvtoQB0B/L7rLPHmd/kkYw/SHuXF+/16QfFzepiA+/d7I/l
         zQAqOS7UblUaJPDELR42W1Mpy/K/BDGfoPlQ1uJdv9rbl1JIuQRYr/DrfvoFwlylOtWE
         9q/yo9NV4x2nn5RLV+OVs5GkEgmLB2Usry1vqqXYOLIGttDLWBCH+D33pf1bOowBq1N2
         ly1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Eq/82tu6X9ZKcrAkx2wEFHmPZM+JAYtAiESTMva+DrQ=;
        b=s1Y2POgV0TyZpgZqzpHc07nxrwA/ZMmQbHcUSJrFESATS8udr7p/PWiCZvIfTablJQ
         +yFAlAIlmbqf7xZs2MV4MZYcESW7Bq0Zt1853VwaCF01XJnl/1OolFUAbH44D2UJkumn
         f3PEDnX1MRg52IFq1BeCWlNIKEA4fCmiEEFNCTnmNzTLdaN/ngxLJuUa0o1rjOILeAvp
         T7bnjzamU4LQpxw2V7k/o34IerqP/mFhczX4y1Ait+9IKzR1zUBN1jW2k8bYj1tU8G6G
         K/fu2nQg1rkFTEzX5zbRoJWW5F6MB5+fPfS+KFsOiRtGj+YJOBBt28HEmcXrLejwdhVQ
         wMrQ==
X-Gm-Message-State: AOAM533zuZ/Qr0x3hLZGUvTg936JO2KIk0IHuWTOhjzR1z/s2Nusyl0j
        zfxp6u1r4k6+z8YPK+Wb05/Na4TgqXg=
X-Google-Smtp-Source: ABdhPJy4YLgL06Y/8GjN5dWUVDk7fQwAVJyn2q3Z/JUYymQbDZsfA6Hgw829zrBBA5ekgw+0gcjigA==
X-Received: by 2002:a05:6a00:a0e:b0:4fd:fa6e:95fc with SMTP id p14-20020a056a000a0e00b004fdfa6e95fcmr11940992pfh.17.1652589954342;
        Sat, 14 May 2022 21:45:54 -0700 (PDT)
Received: from localhost ([2406:7400:63:532d:c4bb:97f7:b03d:2c53])
        by smtp.gmail.com with ESMTPSA id d5-20020a17090a8d8500b001df17c83bbdsm1845919pjo.45.2022.05.14.21.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 21:45:53 -0700 (PDT)
Date:   Sun, 15 May 2022 10:15:49 +0530
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCHv2 1/3] ext4: Move ext4 crypto code to its own file
 crypto.c
Message-ID: <20220515044549.g63qnyuapp54kv76@riteshh-domain>
References: <cover.1652539361.git.ritesh.list@gmail.com>
 <4f6b9ff4411ced6591f858119feb025300ecf918.1652539361.git.ritesh.list@gmail.com>
 <YoB0lYeJv+Cm+C5Y@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoB0lYeJv+Cm+C5Y@sol.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 22/05/14 08:33PM, Eric Biggers wrote:
> On Sat, May 14, 2022 at 10:52:46PM +0530, Ritesh Harjani wrote:
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index a743b1e3b89e..9100f0ba4a52 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -2731,6 +2731,9 @@ extern int ext4_fname_setup_ci_filename(struct inode *dir,
> >  					 struct ext4_filename *fname);
> >  #endif
> >
> > +/* ext4 encryption related stuff goes here crypto.c */
> > +extern const struct fscrypt_operations ext4_cryptops;
> > +
> >  #ifdef CONFIG_FS_ENCRYPTION
>
> Shouldn't the declaration of ext4_cryptops go in the CONFIG_FS_ENCRYPTION block?

Sure yes. I should move that within CONFIG_FS_ENCRYPTION block.

>
> Otherwise this patch looks good, thanks.
>
> Reviewed-by: Eric Biggers <ebiggers@google.com>

Thanks for the review.

-ritesh

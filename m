Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C74E5275C6
	for <lists+linux-fscrypt@lfdr.de>; Sun, 15 May 2022 06:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235546AbiEOEwE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 15 May 2022 00:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235540AbiEOEwD (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 15 May 2022 00:52:03 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4FC6BC35;
        Sat, 14 May 2022 21:52:01 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so11330825pjq.2;
        Sat, 14 May 2022 21:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GSub8ywjLn6OyKjKwFkaiTyzfw5T5otZIoNMcLqyPgU=;
        b=cGvma6yywrTuL7Am9L6IHTtdxATJIw6kJRauzCiggUuNt1D96rVEIOMBFDnBRx4WNr
         5EfKuXsReBdc+oaMiWG/2BR/voZA/MiqTJ9Dvn07QeNBCuu9RiAZh79mQaMuWWqxq97F
         +TKFC2NdeZ/CNFcaP5AgGUuFQeZVpMisUzLodgC+nQVPf/BRMosqDUNJLjsybwvH/2jq
         rJRgrj3qYwoaaP2I1jvxie3zfqbIcbsfvNGsPTq6UwMVoTC43yoRj8U5D0u+3VlU7l2V
         x4ZnVAZ1tWl1qXLd3r4sgLazfGzoxWT2HDssEbO5/ihJo+ulHaEJAztq9/Cmka/DO4CE
         O5VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GSub8ywjLn6OyKjKwFkaiTyzfw5T5otZIoNMcLqyPgU=;
        b=Knrp87kzX/fC5xBgyWtbETR6jBEe9ZUls0nzsKc4/itxlDzg0gXUQVbzqUZH7JTJGI
         iMJAnWGZ5EWkGLnAfaMJES1g4S2sgaEKsGxKpoc+GT44HyxVdQnLx1cCjLGFpIegsVoj
         0thLec68s2su1oJDgZnjl1e5UndShUFPBjE0H24H+289eUFdTjQB0OJh2d7AsRJVf7Nu
         K+0yK2pk02DqQWAsex5zKktNv4zg1pj80w6VMShoEuJkWU6sxhpflrFU47CPKmN8MNJq
         6USwouXRmCDWEN3oTouG/F4AYrFncTkci7CBt8yInZH9CO9TTSw+yU4iwjQB0o9s/ujI
         3nfQ==
X-Gm-Message-State: AOAM531zB3TTGX0XlrrAmSzLlx5asNDI1cDVeaTOkYZPs/Xdn9WpwN4Z
        ndc6fVpu5WRFtnciudvrSMw=
X-Google-Smtp-Source: ABdhPJz9o5R+j9ndoPpvBFrUzXtCiTW+r+brpdDIxLfEYPbqrurbdhmq3mr0MnD2dlePaLp7HY4SEA==
X-Received: by 2002:a17:903:22c1:b0:15e:c3b2:d632 with SMTP id y1-20020a17090322c100b0015ec3b2d632mr12418632plg.0.1652590321186;
        Sat, 14 May 2022 21:52:01 -0700 (PDT)
Received: from localhost ([2406:7400:63:532d:c4bb:97f7:b03d:2c53])
        by smtp.gmail.com with ESMTPSA id g16-20020a170902d5d000b0015eafc485c8sm4382389plh.289.2022.05.14.21.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 21:52:00 -0700 (PDT)
Date:   Sun, 15 May 2022 10:21:56 +0530
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCHv2 3/3] ext4: Refactor and move
 ext4_ioc_get_encryption_pwsalt()
Message-ID: <20220515045156.onskr3gpkhhbdcgv@riteshh-domain>
References: <cover.1652539361.git.ritesh.list@gmail.com>
 <3256b969d6e858414f08e0ca2f5117e76fdc2057.1652539361.git.ritesh.list@gmail.com>
 <YoB2ooMWcb9vTmFt@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoB2ooMWcb9vTmFt@sol.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 22/05/14 08:42PM, Eric Biggers wrote:
> On Sat, May 14, 2022 at 10:52:48PM +0530, Ritesh Harjani wrote:
> > diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
>
> The include <linux/uuid.h> can be removed from this file.

Yes. I will remove this from ioctl.c and will add it to crypto.c
for generate_random_uuid() definition.

>
> > diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
> [...]
> > +int ext4_ioc_get_encryption_pwsalt(struct file *filp, void __user *arg)
>
> ext4 has more functions named "ext4_ioctl_*" thtan "ext4_ioc_*", so it might be
> worth adding those extra 2 letters for consistency.

You are right.

>
> Other than the above minor nits this looks good, thanks!
>
> Reviewed-by: Eric Biggers <ebiggers@google.com>

Thanks for a thorough review.

I will make these changes and send out a v3 soon.

-ritesh

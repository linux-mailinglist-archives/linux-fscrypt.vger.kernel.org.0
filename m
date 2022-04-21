Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EACF50A3A9
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 Apr 2022 17:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243205AbiDUPKh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 Apr 2022 11:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235754AbiDUPKf (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 Apr 2022 11:10:35 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB0118E0F;
        Thu, 21 Apr 2022 08:07:46 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id z6-20020a17090a398600b001cb9fca3210so5444489pjb.1;
        Thu, 21 Apr 2022 08:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iGK6WAimDzk6I7w4MsBcMqAD+Z5lpQcXiFigGEORLjk=;
        b=OEJu4opX2Nj5QLgKTEg9HD0i969aryS55F7jOB2XJQE4+L9kcuVOIDXyMGws+K4mC/
         tSZb9bxtkkN9Kqoe8LwKXcE6Pog4qPd7tDFhvIxKOIDSMXWszPqXuvFRyJXIuIdzgiEf
         OC8tZBboI2y+rssXWq+0CXVtLzF1UQUwrSX3yJg8d1Oz+3PTemCc5jliADqILq3c21Hj
         xAWXpVxoqtu/FJ7uKiMRqa1/ka8BKnaYIV1VOtFaTCAlQwtMAScQHSiDNJjIDyVfRhOG
         HQULHMCGRf923N+756tNvG8vHn0qqUthwIfFbmehpkwN70Yaad6D6vRlLOpPV6fmEP1T
         7jFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iGK6WAimDzk6I7w4MsBcMqAD+Z5lpQcXiFigGEORLjk=;
        b=0OULSdv5pYDf6lDErCpo7BNFulLDC9RbDZfTEQG5I3pre6R39hXiEVPv4ik7IthJzK
         lxXfHtS4Re5s04HqXJW9OcTDvUO7TGh73dz4rVFlylP0lcYos/lJZWe5hWw4OW1kLWZQ
         sVEu4jZquYFx2wRmuZcWs9lpx8ibXrywupKyturOoFOlseRpW5cfhsahgGBga56A7KRd
         bKUZb+UtPD1vhtCKMH5+7KH6ZgdT7aHAOqzfz5ApXgI5QCGQu2Tc4dJ57/idtRqsa9hz
         E8ygnzGfgXHPxVnCumefP5nJN37+L/pVAvMZ2BQ24U6J+/2iL24e4uVG+6cmDNZqzDSn
         UycQ==
X-Gm-Message-State: AOAM531vG00u4iFYaofQmvQi7yJz8rBtE2CTj/afFUM9Infqp3ioMJRH
        7abJ/gjr0BWU6JkEfcJ3PlksnoGe5h8=
X-Google-Smtp-Source: ABdhPJyn2m/BW/KZvuuhHeHH8j6t2vJjJK/lDNy6HAKmBPtIXAZALq/ZjyV2nKpxfz6A1Ln+Jdw0cA==
X-Received: by 2002:a17:90a:3ee4:b0:1cb:c1a6:e5c3 with SMTP id k91-20020a17090a3ee400b001cbc1a6e5c3mr68478pjc.215.1650553665690;
        Thu, 21 Apr 2022 08:07:45 -0700 (PDT)
Received: from localhost ([2406:7400:63:fca5:5639:1911:2ab6:cfe6])
        by smtp.gmail.com with ESMTPSA id v14-20020a17090a6b0e00b001d2bff34228sm3226172pjj.9.2022.04.21.08.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 08:07:44 -0700 (PDT)
Date:   Thu, 21 Apr 2022 20:37:40 +0530
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Subject: Re: [RFC 0/6] ext4: Move out crypto ops to ext4_crypto.c
Message-ID: <20220421150740.bf4xlt2fszbyabel@riteshh-domain>
References: <cover.1650517532.git.ritesh.list@gmail.com>
 <YmEGkAQ+T/3EnVHC@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmEGkAQ+T/3EnVHC@sol.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 22/04/21 12:24AM, Eric Biggers wrote:
> On Thu, Apr 21, 2022 at 10:53:16AM +0530, Ritesh Harjani wrote:
> > Hello,
> >
> > This is 1st in the series to cleanup ext4/super.c, since it has grown quite large.
> > This moves out crypto related ops and few definitions to fs/ext4/ext4_crypto.c
> >
> > Testing
> > =========
> > 1. Tested "-g encrypt" with default configs.
> > 2. Compiled tested on x86 & Power.
> >
> >
> > Ritesh Harjani (6):
> >   fscrypt: Provide definition of fscrypt_set_test_dummy_encryption
> >   ext4: Move ext4 crypto code to its own file ext4_crypto.c
> >   ext4: Directly opencode ext4_set_test_dummy_encryption
> >   ext4: Cleanup function defs from ext4.h into ext4_crypto.c
> >   ext4: Move all encryption related into a common #ifdef
> >   ext4: Use provided macro for checking dummy_enc_policy
> >
> >  fs/ext4/Makefile        |   1 +
> >  fs/ext4/ext4.h          |  81 +++--------------
> >  fs/ext4/ext4_crypto.c   | 192 ++++++++++++++++++++++++++++++++++++++++
> >  fs/ext4/super.c         | 158 ++++-----------------------------
> >  include/linux/fscrypt.h |   7 ++
> >  5 files changed, 227 insertions(+), 212 deletions(-)
> >  create mode 100644 fs/ext4/ext4_crypto.c
>
> How about calling it crypto.c instead of ext4_crypto.c?  It is already in the
> ext4 directory, so ext4 is implied.

Sure will do so in next revision which can also cover any other comments from
others.

>
> Otherwise this patchset looks good to me.

Sure thanks. May I add your Reviewed-by in next version if I don't see any major
changes?

>
> Did you consider moving any of the other CONFIG_FS_ENCRYPTION code blocks into
> the new file as well?  The implementation of FS_IOC_GET_ENCRYPTION_PWSALT might
> be a good candidate too.

Sure, thanks for pointing out. I will take a look at it for next patch series or
so.

-ritesh

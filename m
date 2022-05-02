Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9A3517184
	for <lists+linux-fscrypt@lfdr.de>; Mon,  2 May 2022 16:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237615AbiEBOaK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 2 May 2022 10:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237408AbiEBOaK (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 2 May 2022 10:30:10 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A052E01D;
        Mon,  2 May 2022 07:26:41 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id c23so12621281plo.0;
        Mon, 02 May 2022 07:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=spyH+CLq2sEjiIvISgmp7HyxnvRaZjFzXv1/VqME9OM=;
        b=p7s3i+3I4gekIldbTsauL6caVQF4GGaU3CsD0FyDuCmF3st6wnS2T10gTkHnTqxYjU
         pMda9t3yhViOZ2cVU0zIIZlyIiyszxErgi4Ti3NWBXQKBtzxSk+SQMwSciI1PJ4K0PDi
         MnpJGfFvmtzdqQATcSrjsJj+1HitoCYfX1orA+ywTNQqtSjtvpcaWrE0t+uTn8GfLaa3
         cJER+PyGNl9plakxAiW8Z4cGV0EfHXmxcRqj/OFOuppUtXjyKtKBNod8psAkrymp0+V8
         VpMMPvO08KDPlbEmdEc65urO4wdRd9kk16FREjUaKEUfuScTGa9uRMUBfe1LTE8rJNU1
         TYOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=spyH+CLq2sEjiIvISgmp7HyxnvRaZjFzXv1/VqME9OM=;
        b=ancsbO+7/fDVO3rE7VqqQ/ifX2Fuu/tRH0Gp71fup9K1I3vqRhVsVxs3e7jrqU19/x
         kQWu4y5zlmLPVwE0CxPn4UdjVTxPT2CyVtixJj3gkyWRAmEJE87xf6yEshPGea533Wp5
         /Njgd6PiHYX1zRo6GKNwnakepeIrvwuRIXiJDcCs0gVl4eYpj4ZDj+JAT2R9fZG+kM82
         rr4i1H+szMvSb3Slq34sCDEa/dO9jRNj+wbhgRiJHMgl0cPE1yP7j59WdhpY0vEslpmy
         nSrL5xnVZHtJg7IQe9wpwNpMMDm7pzkAzFw2gB54vd8EVD4yeZHi99b9FxcfDr+NJGDS
         Kfxw==
X-Gm-Message-State: AOAM530Ns+kgqGrGhKQyK0X7rsPd3dcJXzxMFSEUeuJVamB3fSiGgpdB
        pM7BuCh7QLBg3pM8Ais3yYg=
X-Google-Smtp-Source: ABdhPJxvn7ztNWNCIqrR3lvVLbL37wCQBnsrphn6zK4z4JFdnygcnrOcwHvJG2DGM2yV06VRzygxiw==
X-Received: by 2002:a17:90b:4ac7:b0:1d1:c730:579c with SMTP id mh7-20020a17090b4ac700b001d1c730579cmr18473458pjb.189.1651501600926;
        Mon, 02 May 2022 07:26:40 -0700 (PDT)
Received: from localhost ([122.171.172.208])
        by smtp.gmail.com with ESMTPSA id g10-20020a170902868a00b0015e8d4eb27csm4711327plo.198.2022.05.02.07.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 07:26:40 -0700 (PDT)
Date:   Mon, 2 May 2022 19:56:36 +0530
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Subject: Re: [RFC 0/6] ext4: Move out crypto ops to ext4_crypto.c
Message-ID: <20220502142636.ud46y4bwr76g5emn@riteshh-domain>
References: <cover.1650517532.git.ritesh.list@gmail.com>
 <Ym40Tx0W8Mvk8XOg@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ym40Tx0W8Mvk8XOg@sol.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 22/05/01 12:18AM, Eric Biggers wrote:
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
>
> FYI, the patchset
> https://lore.kernel.org/linux-ext4/20220501050857.538984-1-ebiggers@kernel.org
> I just sent out cleans up how the test_dummy_encryption mount option is handled.
> It would supersede patches 1, 3, 5, and 6 of this series (since those all only
> deal with test_dummy_encryption-related code).

Sure got it.

>
> To avoid conflicting changes, maybe you should just focus on your patches 2 and
> 4 for now, along with possibly FS_IOC_GET_ENCRYPTION_PWSALT as I mentioned?
> There shouldn't be any overlap that way.

Yes, agreed with al of above points Eric. Will make the changes and send a new
revision.

-ritesh

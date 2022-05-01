Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69405164BD
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 May 2022 16:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347579AbiEAOcB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 May 2022 10:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347618AbiEAOb5 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 May 2022 10:31:57 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47867205CB
        for <linux-fscrypt@vger.kernel.org>; Sun,  1 May 2022 07:28:29 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id a76so2269560qkg.12
        for <linux-fscrypt@vger.kernel.org>; Sun, 01 May 2022 07:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Pn8HkU7QQBVVwIjLYoARJB5iiMsFMcx8Bt/8i9MDqSc=;
        b=5ZTBzi3w2hHCYBjERi5vW1c2hk1MMXO5dWPq729fg1wHt/OX2cKmEA966FVmEYPK6b
         FNWY8NlCBVoGkd4wxNtfK+MyvmQAqHA3yXmYSWyjz1EKcBIkPMd6nK7IQauZ4FeaZrbb
         nexxwCAdh2er2Sj/x6N9zP7NrhSGHBxLnm0YIxle3p2UHc6RX1qJUzHl+wpUmALPEWBD
         2m59h/kGX1eekeDxYs8xxmBlJ+7vMbo+0/yQEKczr9Q7w2r6LmxWh1BHJwA9e3SdrDVI
         e4RIPi8EcwFuWv/VQZlj+VDcFUfpGeHhKBywJ8dDu2396xID2VXphfP0w/vCZyjT3Mea
         JdpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Pn8HkU7QQBVVwIjLYoARJB5iiMsFMcx8Bt/8i9MDqSc=;
        b=5ZHwgs+hunaR89XZZ5LR/AMbrsBEQW0G+o2DXEYi1KMRgaNMYHvepEZP7ivijBXOA9
         Xts4sDSYUULePOG/elPIZENDkg4OhIUOsC6Pu+fR5gZmmWIzUuWpQaZGbrM1tkHVuFRA
         PF5yF/c7a5LVuEmMxwSxrrfao+TMquhoCyV80F4bkaBCq5mp6c6NKpnjU8Aa0CTDpNeT
         diPU28TiSU7T/OXm6GR1Nin6edGfy5/52SLrxzNvDUN0l9Q+eE292shxZnG6XKmLfMH5
         7+exmvyoAOW1CTnrv095VFo9a907xdmOGisasLUNEhwf27nxjYDPYPWG+DNZ4nr0NTpG
         0OrA==
X-Gm-Message-State: AOAM531j1nT6fcdavp4pF68DBmj9bMMf19N4uuTYfTcCyxSLn9F9VSk3
        +/bi66oofj79CMMXii3p0s/eBQ==
X-Google-Smtp-Source: ABdhPJxBSumdv7NFEa/CbBiepXpJd8g+K0RKfcPzKAjlFNN5J4MDDjFemxzhbX38mcgSDqt9lajMXQ==
X-Received: by 2002:a05:620a:74b:b0:69b:db1d:f91e with SMTP id i11-20020a05620a074b00b0069bdb1df91emr5770863qki.286.1651415308350;
        Sun, 01 May 2022 07:28:28 -0700 (PDT)
Received: from localhost ([173.95.209.66])
        by smtp.gmail.com with ESMTPSA id q77-20020a37a750000000b0069fc13ce1fcsm2840637qke.45.2022.05.01.07.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 07:28:27 -0700 (PDT)
Date:   Sun, 1 May 2022 10:28:27 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v9 2/5] common/verity: support btrfs in generic fsverity
 tests
Message-ID: <Ym6ZC8Ag2KEiJheZ@localhost.localdomain>
References: <cover.1651012461.git.boris@bur.io>
 <3ac2f088ab31052659aa37a7e2f0821ef7b95e60.1651012461.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ac2f088ab31052659aa37a7e2f0821ef7b95e60.1651012461.git.boris@bur.io>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Apr 26, 2022 at 03:40:13PM -0700, Boris Burkov wrote:
> generic/572-579 have tests for fsverity. Now that btrfs supports
> fsverity, make these tests function as well. For a majority of the tests
> that pass, simply adding the case to mkfs a btrfs filesystem with no
> extra options is sufficient.
> 
> However, generic/574 has tests for corrupting the merkle tree itself.
> Since btrfs uses a different scheme from ext4 and f2fs for storing this
> data, the existing logic for corrupting it doesn't work out of the box.
> Adapt it to properly corrupt btrfs merkle items.
> 
> 576 does not run because btrfs does not support transparent encryption.
> 
> This test relies on the btrfs implementation of fsverity in the patch:
> btrfs: initial fsverity support
> 
> and on btrfs-corrupt-block for corruption in the patches titled:
> btrfs-progs: corrupt generic item data with btrfs-corrupt-block
> btrfs-progs: expand corrupt_file_extent in btrfs-corrupt-block
> 
> Signed-off-by: Boris Burkov <boris@bur.io>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef

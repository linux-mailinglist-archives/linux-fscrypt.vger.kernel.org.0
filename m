Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C38624D5A60
	for <lists+linux-fscrypt@lfdr.de>; Fri, 11 Mar 2022 06:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346416AbiCKFTu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 11 Mar 2022 00:19:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346387AbiCKFTt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 11 Mar 2022 00:19:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E526A53B40;
        Thu, 10 Mar 2022 21:18:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52591B82A78;
        Fri, 11 Mar 2022 05:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7EA5C340EC;
        Fri, 11 Mar 2022 05:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646975923;
        bh=5iTm8AeQHWcspGp/ADW+jMjLy3o3qtcRvAvIkXEZzfg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hjo2jWAf5hpi3mLDP7pod3VhSowZ8b9tCqUFwFAGXsH4lLvV8Ji3hQdeQiLrfHvsS
         zFQhCr2Bp+8DndACGpNH0eC5Nwc/puIVOxbOZMsJYnvDLuWbSDZQ6gJVVL6VKVYVJY
         UIY/kg3zoYjxc/zzF8heQCT/2rv5Ir3lLOKPIl/OuaMml6Gy1o3jQWkk/7UsSRM5YK
         ffGGyVJFju0VBTwmtWc7DJBTaYB9vvxsXLp48vOfYFFPPIDmvOWJNkYsy4oabsxCpu
         /oxkfczBlfSN6h7Y68Lb82OapBKBnM+5iKH32wC9gcOd5/X5ueF08wBiilzvAWxOhz
         xpvm1FfvWTU2A==
Date:   Thu, 10 Mar 2022 21:18:42 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>,
        Israel Rukshin <israelr@nvidia.com>
Subject: Re: [PATCH v5 3/3] fscrypt: add support for hardware-wrapped keys
Message-ID: <YirbspMr5CAnlWAC@sol.localdomain>
References: <20220228070520.74082-1-ebiggers@kernel.org>
 <20220228070520.74082-4-ebiggers@kernel.org>
 <c1da8aec-7bb9-dd88-7500-a09d29bbc1e4@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1da8aec-7bb9-dd88-7500-a09d29bbc1e4@acm.org>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Mar 03, 2022 at 05:03:10PM -0800, Bart Van Assche wrote:
> On 2/27/22 23:05, Eric Biggers wrote:
> > diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
> > index 9f4428be3e362..884c5bf526a05 100644
> > --- a/include/uapi/linux/fscrypt.h
> > +++ b/include/uapi/linux/fscrypt.h
> > @@ -20,6 +20,7 @@
> >   #define FSCRYPT_POLICY_FLAG_DIRECT_KEY		0x04
> >   #define FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64	0x08
> >   #define FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32	0x10
> > +#define FSCRYPT_POLICY_FLAG_HW_WRAPPED_KEY	0x20
> >   /* Encryption algorithms */
> >   #define FSCRYPT_MODE_AES_256_XTS		1
> > @@ -115,7 +116,7 @@ struct fscrypt_key_specifier {
> >    */
> >   struct fscrypt_provisioning_key_payload {
> >   	__u32 type;
> > -	__u32 __reserved;
> > +	__u32 flags;
> >   	__u8 raw[];
> >   };
> > @@ -124,7 +125,9 @@ struct fscrypt_add_key_arg {
> >   	struct fscrypt_key_specifier key_spec;
> >   	__u32 raw_size;
> >   	__u32 key_id;
> > -	__u32 __reserved[8];
> > +#define FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED			0x00000001
> > +	__u32 flags;
> > +	__u32 __reserved[7];
> >   	__u8 raw[];
> >   };
> 
> Is it allowed to use _Static_assert() in UAPI header files? There are
> already some static_assert() checks under include/linux to verify the size
> of certain data structures. gcc supports _Static_assert() since version 4.6.
> That is older than the minimum required gcc version to build the kernel.
> 

Are you requesting static assertions that verify that the size of each fscrypt
UAPI struct is a certain value?  Kernel UAPIs generally don't bother with that
sort of thing, but it does seem like a good idea.  I'll add them as a cleanup,
but it's orthogonal to this patch series.

To answer your direct question, I believe that _Static_assert generally can't be
used in UAPI header files, as it's a C11 feature and UAPI headers are included
by arbitrary userspace programs.  These assertions will need to be in
kernel-only code, either in a kernel-only file such as include/linux/fscrypt.h,
or in an #ifdef __KERNEL__ section of the UAPI header.  Also, the kernel already
conventionally uses BUILD_BUG_ON() for static assertions.

- Eric

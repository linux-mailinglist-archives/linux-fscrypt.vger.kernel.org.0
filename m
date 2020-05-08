Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A201CB8FD
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 May 2020 22:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgEHU3j (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 8 May 2020 16:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726811AbgEHU3h (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 8 May 2020 16:29:37 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9ABC05BD0A
        for <linux-fscrypt@vger.kernel.org>; Fri,  8 May 2020 13:29:36 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id b8so1359930pgi.11
        for <linux-fscrypt@vger.kernel.org>; Fri, 08 May 2020 13:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u+UVXV6ltTLEXRg71t8ZlanM7FX+NKobsCkEXtg96NE=;
        b=RYelO5xukoxW/3L2JkFg5tmZjnglITAKD+MtkemsP4cYGsp1xVe2wKSLENvSgIdHsX
         vJEM4DVmFUsMREPGy11z9HYp3s+bimMEI+E7V2jYclf+2NSk16LxuYudzAzXYEn+aUnq
         M9G7wXu19gtldXMWAbsOJNmNcxPB314nhuUCEREf9kr0mfeXHjFdwiovK7nU33Xp5GDF
         Wi2VpiKa4+k3AFjmYirN2mFplQFJiSpvC+twMPYBd8mnsf53EgiHQgPt2kYVPmbjGMz1
         9qYprWaiLvP2WtPec3tUFbpNhGSNch3HN569tbT9JFMVmccT1ZDGVO5PvFC0P1QWqUQF
         ghag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u+UVXV6ltTLEXRg71t8ZlanM7FX+NKobsCkEXtg96NE=;
        b=BMlvNDcKefwtOgRQW8H/8n9AVP5nCe08biiOYYaYvn8MHQbrkryKOBN5Jg97N66loP
         HULyuHWsYzObO3ZGDF0A5tSxoCfzMuiDOXpemHDu66/ViPZ+bLD5Qi54Og5pNB1dQm+E
         1fESGlo1cTyZMeZ35X48SFzHlw/raVX7OtODXaT34p3LnCBhejcqZ61KxVxaAfBstY0L
         tChM+dT28XErmLHBrladmsC2xN2VcFrs3/Hkpp/ZlrqSu9yGMkX6lm2EoaTzKlTLKFu3
         cBvFFeI3DIplNXOsnUP92jAA6RZ/ERBTMT9ZJ6XyBzXcxRteBpiS+HrEWMNxEQ2knupO
         rxNw==
X-Gm-Message-State: AGi0Pua1D0f8WvXNq8REn0Jlle7/aQQ3m4WmIR+PlKYNcbx2n7IqyfHO
        cqJa21QNVOTFtUHXTcNVluZzfg==
X-Google-Smtp-Source: APiQypLCUECJxgUiSkcMPk0rlGPzCyI65jqxd7/f9HwhCEcSdXX9Vsv2UyFO2+fMqyxSvtcI5p4OTQ==
X-Received: by 2002:a63:d40a:: with SMTP id a10mr3495198pgh.71.1588969775920;
        Fri, 08 May 2020 13:29:35 -0700 (PDT)
Received: from google.com (240.242.82.34.bc.googleusercontent.com. [34.82.242.240])
        by smtp.gmail.com with ESMTPSA id b15sm2616111pfd.139.2020.05.08.13.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 13:29:35 -0700 (PDT)
Date:   Fri, 8 May 2020 20:29:31 +0000
From:   Satya Tangirala <satyat@google.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Steev Klimaszewski <steev@kali.org>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Can Guo <cang@codeaurora.org>,
        Elliot Berman <eberman@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC PATCH v4 4/4] scsi: ufs-qcom: add Inline Crypto Engine
 support
Message-ID: <20200508202931.GA236461@google.com>
References: <20200501045111.665881-1-ebiggers@kernel.org>
 <20200501045111.665881-5-ebiggers@kernel.org>
 <31fa95e5-7757-96ae-2e86-1f54959e3a6c@linaro.org>
 <20200507180435.GB236103@gmail.com>
 <20200507180838.GC236103@gmail.com>
 <150ddaaf-12ec-231e-271a-c65b1d88d30f@kali.org>
 <20200508202513.GA233206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508202513.GA233206@gmail.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, May 08, 2020 at 01:25:13PM -0700, Eric Biggers wrote:
> On Fri, May 08, 2020 at 03:18:23PM -0500, Steev Klimaszewski wrote:
> > 
> > On 5/7/20 1:08 PM, Eric Biggers wrote:
> > > On Thu, May 07, 2020 at 11:04:35AM -0700, Eric Biggers wrote:
> > >> Hi Thara,
> > >>
> > >> On Thu, May 07, 2020 at 08:36:58AM -0400, Thara Gopinath wrote:
> > >>>
> > >>> On 5/1/20 12:51 AM, Eric Biggers wrote:
> > >>>> From: Eric Biggers <ebiggers@google.com>
> > >>>>
> > >>>> Add support for Qualcomm Inline Crypto Engine (ICE) to ufs-qcom.
> > >>>>
> > >>>> The standards-compliant parts, such as querying the crypto capabilities
> > >>>> and enabling crypto for individual UFS requests, are already handled by
> > >>>> ufshcd-crypto.c, which itself is wired into the blk-crypto framework.
> > >>>> However, ICE requires vendor-specific init, enable, and resume logic,
> > >>>> and it requires that keys be programmed and evicted by vendor-specific
> > >>>> SMC calls.  Make the ufs-qcom driver handle these details.
> > >>>>
> > >>>> I tested this on Dragonboard 845c, which is a publicly available
> > >>>> development board that uses the Snapdragon 845 SoC and runs the upstream
> > >>>> Linux kernel.  This is the same SoC used in the Pixel 3 and Pixel 3 XL
> > >>>> phones.  This testing included (among other things) verifying that the
> > >>>> expected ciphertext was produced, both manually using ext4 encryption
> > >>>> and automatically using a block layer self-test I've written.
> > >>> Hello Eric,
> > >>>
> > >>> I am interested in testing out this series on 845, 855 and if possile on 865
> > >>> platforms. Can you give me some more details about your testing please.
> > >>>
> > >> Great!  You can test this with fscrypt, a.k.a. ext4 or f2fs encryption.
> > >>
> > >> A basic manual test would be:
> > >>
> > >> 1. Build a kernel with:
> > >>
> > >> 	CONFIG_BLK_INLINE_ENCRYPTION=y
> > >> 	CONFIG_FS_ENCRYPTION=y
> > >> 	CONFIG_FS_ENCRYPTION_INLINE_CRYPT=y
> > > Sorry, I forgot: 'CONFIG_SCSI_UFS_CRYPTO=y' is needed too.
> > >
> > > - Eric
> > 
> > I took a look into this as well - is v12 the latest of the fscrypt
> > inline crypto patches?
> > 
> > I see a EXPORT_SYMBOL_GPL(fscrypt_inode_uses_inline_crypto) but it seems
> > like it should be EXPORT_SYMBOL_GPL(__fscrypt_inode_uses_inline_crypto)
> > otherwise you end up with
> > 
> > 
> > WARNING: modpost: "fscrypt_inode_uses_inline_crypto" [vmlinux] is a
> > static EXPORT_SYMBOL_GPL
> > 
> > 
> > when you have something like CONFIG_F2FS_FS=m
> > 
> > 
> > Apologies but I'm not sure where the original patchset is to send as a
> > reply to them.
> 
> The original patchset is at
> https://lkml.kernel.org/r/20200430115959.238073-1-satyat@google.com/
> 
> Yes, v12 is the latest version, and yes that's a bug.  The export needs double
> underscores.  Satya will fix it when he sends out v13.
> 
> - Eric
Yup, that's the plan. Thanks!

Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1BA6BDB65
	for <lists+linux-fscrypt@lfdr.de>; Thu, 16 Mar 2023 23:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjCPWL0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 16 Mar 2023 18:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjCPWLU (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 16 Mar 2023 18:11:20 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 197DA18B3B;
        Thu, 16 Mar 2023 15:10:57 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id 49B962057034; Thu, 16 Mar 2023 15:10:36 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 49B962057034
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1679004636;
        bh=91dVpHPjN0I18MHMEPytTYoAIcj3tyyfhEHK1iqzMPQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HqM5s8Lv4cdYH4FTxM8ECxW+qlq9xYC5uyrjWzmUgAox9VPD8YUiKBlVI33RA3C4V
         Fldv/wo+3U0Z71kycUAZ9D1j/mCkqhwZbRpTf8J90aOuMRBDyDQ/3lf1roICQ0vkut
         tuKKCPaYpChsjgoYGO1HOGIC8r40sD49SxPTvRaA=
Date:   Thu, 16 Mar 2023 15:10:36 -0700
From:   Fan Wu <wufan@linux.microsoft.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v9 11/16] ipe: add support for dm-verity as a trust
 provider
Message-ID: <20230316221036.GA22567@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-12-git-send-email-wufan@linux.microsoft.com>
 <CAHC9VhRdm_xpXNQvSVO2hkx2js=_zzo2DiQ6PvEjAEet4OjxNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhRdm_xpXNQvSVO2hkx2js=_zzo2DiQ6PvEjAEet4OjxNw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Mar 02, 2023 at 02:08:04PM -0500, Paul Moore wrote:
> 
> If you had both IPE and dm-verity enabled in your kernel build, is
> there ever a case where you wouldn't want IPE_PROP_DM_VERITY?  I
> suspect you can just have IPE and dm-verity select IPE_PROP_DM_VERITY
> and not bother the user/admin with the additional Kconfig knob.
> 
Sorry for the late reply, I was relocating to a new country and it
took me some time to settle down.

I have read your comments and I will try to answer some questions
that I can answer right now. For the remaining questions, I need more
time to get more context and information. I will get back to you
as soon as possible.

For this one I agree just have IPE and dm-verity select IPE_PROP_DM_VERITY
is better, I will update this in the next version.

> 
> --
> paul-moore.com

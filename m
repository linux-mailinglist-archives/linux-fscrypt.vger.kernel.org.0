Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0D0F683A2C
	for <lists+linux-fscrypt@lfdr.de>; Wed,  1 Feb 2023 00:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbjAaXBC (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 31 Jan 2023 18:01:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjAaXBC (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 31 Jan 2023 18:01:02 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5DAD64ED23;
        Tue, 31 Jan 2023 15:01:01 -0800 (PST)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id 02B2720E1A45; Tue, 31 Jan 2023 15:01:01 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 02B2720E1A45
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675206061;
        bh=j1VoMU02KeLtjY8TDWq+rO4UuOvmlBPIER8JkQji2a8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TggEBO122eJ2C7kl74c+1SFcSJF6DkRp8p/6zKNdTJSzcQvm+ox90trpwmt9MaD16
         IA13KrKuItDN//TlUQ6WNwy6rn8jpm1/6q1u1qz9vJZwJ7lTGIAYRz9qZ0H2E4RIfZ
         vL2gNFuJd9e7cGHa1n52ljy9XW5xv9jEo/adSYpU=
Date:   Tue, 31 Jan 2023 15:01:00 -0800
From:   Fan Wu <wufan@linux.microsoft.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, paul@paul-moore.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v9 09/16] block|security: add LSM blob to block_device
Message-ID: <20230131230100.GA30104@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-10-git-send-email-wufan@linux.microsoft.com>
 <Y9jXJ8FrmAnzob7w@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9jXJ8FrmAnzob7w@infradead.org>
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

On Tue, Jan 31, 2023 at 12:53:59AM -0800, Christoph Hellwig wrote:
> On Mon, Jan 30, 2023 at 02:57:24PM -0800, Fan Wu wrote:
> > From: Deven Bowers <deven.desai@linux.microsoft.com>
> > 
> > block_device structures can have valuable security properties,
> > based on how they are created, and what subsystem manages them.
> 
> That's a lot of cloudy talk but no real explanation.

Sorry for being too general here. Currently the only use target of this hook is dm-verity. We use the newly added security hook to save the dm-verity roothash and signature to the new bdev security blob during the bdev creation time, so LSMs can leverage this information to protect the system. 

I will add this example in the next version.

-Fan

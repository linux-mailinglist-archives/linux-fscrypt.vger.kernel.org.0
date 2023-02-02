Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC50687736
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Feb 2023 09:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbjBBIWS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Feb 2023 03:22:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbjBBIWR (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Feb 2023 03:22:17 -0500
Received: from frasgout12.his.huawei.com (frasgout12.his.huawei.com [14.137.139.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0DE834BB;
        Thu,  2 Feb 2023 00:22:13 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.229])
        by frasgout12.his.huawei.com (SkyGuard) with ESMTP id 4P6s4b6HpTz9xFrR;
        Thu,  2 Feb 2023 16:13:51 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
        by APP2 (Coremail) with SMTP id GxC2BwBHE1qQcttjhtrmAA--.14473S2;
        Thu, 02 Feb 2023 09:21:48 +0100 (CET)
Message-ID: <903062f7b2e2709ae0e4416545ffadd91c132676.camel@huaweicloud.com>
Subject: Re: [RFC PATCH v9 10/16] dm-verity: consume root hash digest and
 signature data via LSM hook
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     Fan Wu <wufan@linux.microsoft.com>
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
Date:   Thu, 02 Feb 2023 09:21:24 +0100
In-Reply-To: <20230201232639.GB9075@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
         <1675119451-23180-11-git-send-email-wufan@linux.microsoft.com>
         <4f029a41d80d883d9b4729cbc85211955c9efe8e.camel@huaweicloud.com>
         <20230201232639.GB9075@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: GxC2BwBHE1qQcttjhtrmAA--.14473S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Kw4ftFW5tw1fXF4DKr4xtFb_yoW8JF4xpF
        1UWayYgrn5KasrGrnaya1fArWIkrWYv343Xr15Xw18CF98ur1IvF1FkFW5Za9F9r95C3WF
        vFW0qa47Zwn8A3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UZ18PUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQAQBF1jj4huJgABsl
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, 2023-02-01 at 15:26 -0800, Fan Wu wrote:
> On Tue, Jan 31, 2023 at 02:22:01PM +0100, Roberto Sassu wrote:
> > On Mon, 2023-01-30 at 14:57 -0800, Fan Wu wrote:
> > > From: Deven Bowers <deven.desai@linux.microsoft.com>
> > > 
> > > dm-verity provides a strong guarantee of a block device's integrity. As
> > > a generic way to check the integrity of a block device, it provides
> > > those integrity guarantees to its higher layers, including the filesystem
> > > level.
> > 
> > I think you could reuse most of is_trusted_verity_target(), in
> > particular dm_verity_get_root_digest().
> > 
> > And probably, the previous patch is not necessary.
> > 
> > Roberto
> > 
> Thanks for the info. This function seems could be used to get the roothash
> but for saving the signature we still need the hook function in the previous
> patch.

Uhm, look at the LoadPin case. It does not need to temporarily store
the root digest in a security blob. It evaluates it directly.

Well, ok, dm_verity_loadpin_is_bdev_trusted() looks for trusted digests
in the dm_verity_loadpin_trusted_root_digests list. So, something
equivalent needs to be made for IPE (or you just get the digest).
However, I find not introducing new hooks and evaluating the
information directly more efficient.

Roberto


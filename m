Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572A4687BD2
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Feb 2023 12:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjBBLMd (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Feb 2023 06:12:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbjBBLM2 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Feb 2023 06:12:28 -0500
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D4879634;
        Thu,  2 Feb 2023 03:12:24 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout11.his.huawei.com (SkyGuard) with ESMTP id 4P6wLH1s6Xz9xHw6;
        Thu,  2 Feb 2023 18:40:55 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
        by APP2 (Coremail) with SMTP id GxC2BwBnNl3+lNtjGVTnAA--.14834S2;
        Thu, 02 Feb 2023 11:48:42 +0100 (CET)
Message-ID: <7dc9963c563d0b55bb35109be012e355eef13882.camel@huaweicloud.com>
Subject: Re: [RFC PATCH v9 00/16] Integrity Policy Enforcement LSM (IPE)
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
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org
Date:   Thu, 02 Feb 2023 11:48:18 +0100
In-Reply-To: <20230201004852.GB30104@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
         <033335b26f6becdc3dc0325ef926efd94fcc4dda.camel@huaweicloud.com>
         <20230201004852.GB30104@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: GxC2BwBnNl3+lNtjGVTnAA--.14834S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGw4rWw4DXFWxCryUCF1xXwb_yoW5CFW8pF
        WagayYkr1DKFs2yw1vy3WSqayYv395Ja1UJr98tryUAa15ur1UZF43Ka4Y93W7ur1kZ34Y
        vF42vr9rAF1UCaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
        6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUFDGOUUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAQBF1jj4RztQAEsh
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, 2023-01-31 at 16:48 -0800, Fan Wu wrote:
> On Tue, Jan 31, 2023 at 03:22:05PM +0100, Roberto Sassu wrote:
> > On Mon, 2023-01-30 at 14:57 -0800, Fan Wu wrote:
> > > IPE has two known gaps:
> > > 
> > > 1. IPE cannot verify the integrity of anonymous executable memory, such as
> > >   the trampolines created by gcc closures and libffi (<3.4.2), or JIT'd code.
> > >   Unfortunately, as this is dynamically generated code, there is no way
> > >   for IPE to ensure the integrity of this code to form a trust basis. In all
> > >   cases, the return result for these operations will be whatever the admin
> > >   configures the DEFAULT action for "EXECUTE".
> > 
> > I think it would be useful to handle special cases, for example you
> > could allow a process that created a file with memfd to use it, at the
> > condition that nobody else writes it.
> > 
> > This would be required during the boot, otherwise services could fail
> > to start (depending on the policy).
> > 
> Thanks for the suggestion. I agree with your opinion and I think supporting
> memfd is possible but restricting read/write needs more hooks. We would like
> to avoid adding more complexity to this initial posting as necessary. 
> We will consider this as a future work and will post follow-on patches
> in the future.

Ok, maybe it is necessary to specify better the scope of IPE, why the
current implementation can be considered as complete.

If we say, IPE can only allow/deny operations on system components with
immutable security properties, clearly memfd as a component cannot
fullfill this goal due to the non-immutability. This would apply to any
component allowing modifications.

How to address this? What is the immutable property then?

In the case of memfd, intuitively, a useful property for integrity
could be for example that the content can be accessed/modified by only
one process. No other (possibly malicious) processes can tamper with
that file.

So, it is true, to make this property immutable more hooks are needed.
But should it be something that IPE does? Or it should be done by an
external component (another LSM) that does the enforcement and reports
to IPE that the property is true? Theoretically (with a proper policy),
existing LSMs could be used for that purpose too.

I would say more the second, it should not be IPE job, so that IPE can
exclusively focus on evaluating properties, not making sure that the
properties are immutable.

Roberto

> -Fan
> 
> > > 2. IPE cannot verify the integrity of interpreted languages' programs when
> > >   these scripts invoked via ``<interpreter> <file>``. This is because the
> > >   way interpreters execute these files, the scripts themselves are not
> > >   evaluated as executable code through one of IPE's hooks. Interpreters
> > >   can be enlightened to the usage of IPE by trying to mmap a file into
> > >   executable memory (+X), after opening the file and responding to the
> > >   error code appropriately. This also applies to included files, or high
> > >   value files, such as configuration files of critical system components.
> > 
> > Ok, it is a well known issue. Hopefully, it will be fixed soon.
> > 
> > Roberto
> > 


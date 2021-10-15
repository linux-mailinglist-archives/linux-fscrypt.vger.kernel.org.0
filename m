Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B2142FC00
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Oct 2021 21:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242705AbhJOT1z (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 Oct 2021 15:27:55 -0400
Received: from linux.microsoft.com ([13.77.154.182]:51974 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242676AbhJOT1y (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 Oct 2021 15:27:54 -0400
Received: from [10.137.106.139] (unknown [131.107.159.11])
        by linux.microsoft.com (Postfix) with ESMTPSA id 50A6D20B9D2C;
        Fri, 15 Oct 2021 12:25:47 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 50A6D20B9D2C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634325947;
        bh=iz0OUUGcbTJk4nrU+ApuutZ1DanuurOwgDRQYPbpGYg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=j35gnGlO9Cn/z/bxPioO0Bs7FWnJVMl3oznd4K+vOiayEoS/zpJ46fPC3THh6KPYk
         k6ZlmeEffCer/uhY0m0oEMHJ5OiHuwD3CrhQ7R7PPkkkLwD3YQpkMtJ3VX9dd50urh
         HDOHaFVOjVtI693ZRpcyX8d4NAN+o0Z1MUujXyh4=
Message-ID: <8802b1ff-3028-642a-22c5-bc4896450a60@linux.microsoft.com>
Date:   Fri, 15 Oct 2021 12:25:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH v7 07/16] ipe: add auditing support
Content-Language: en-US
To:     Steve Grubb <sgrubb@redhat.com>, corbet@lwn.net, axboe@kernel.dk,
        agk@redhat.com, snitzer@redhat.com, ebiggers@kernel.org,
        tytso@mit.edu, paul@paul-moore.com, eparis@redhat.com,
        jmorris@namei.org, serge@hallyn.com, linux-audit@redhat.com
Cc:     linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
        jannh@google.com, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
 <1634151995-16266-8-git-send-email-deven.desai@linux.microsoft.com>
 <2159283.iZASKD2KPV@x2>
From:   Deven Bowers <deven.desai@linux.microsoft.com>
In-Reply-To: <2159283.iZASKD2KPV@x2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 10/13/2021 1:02 PM, Steve Grubb wrote:

> Hello,
>
> On Wednesday, October 13, 2021 3:06:26 PM EDT deven.desai@linux.microsoft.com
> wrote:
>> Users of IPE require a way to identify when and why an operation fails,
>> allowing them to both respond to violations of policy and be notified
>> of potentially malicious actions on their systens with respect to IPE
>> itself.
> Would you mind sending examples of audit events so that we can see what the
> end result is? Some people add them to the commit text. But we still need to
> see what they look like.
>
> Thanks,
> -Steve

Sure, sorry. I’ll add them to the commit description (and the documentation
patch at the end) for v8 – In the interest of asynchronous feedback, I’ve
copied the relevant examples:

AUDIT1420 IPE ctx_pid=229 ctx_op=EXECUTE ctx_hook=MMAP ctx_enforce=0
ctx_comm="grep" ctx_pathname="/usr/lib/libc-2.23.so"
ctx_ino=532 ctx_dev=vda rule="DEFAULT op=EXECUTE action=DENY"

AUDIT1420 IPE ctx_pid=229 ctx_op=EXECUTE ctx_hook=MMAP ctx_enforce=0
ctx_comm="grep" ctx_pathname="/usr/lib/libc-2.23.so"
ctx_ino=532 ctx_dev=vda rule="DEFAULT action=DENY"

AUDIT1420 IPE ctx_pid=253 ctx_op=EXECUTE ctx_hook=MMAP ctx_enforce=1
ctx_comm="anon" rule="DEFAULT op=EXECUTE action=DENY"

These three audit records represent various types of results after 
evaluating
the trust of a resource. The first two differ in the rule that was 
matched in
IPE's policy, the first being an operation-specific default, the second 
being
a global default. The third is an example of what is audited when anonymous
memory is blocked (as there is no way to verify the trust of an anonymous
page).

The remaining three events, AUDIT_TRUST_POLICY_LOAD (1421),
AUDIT_TRUST_POLICY_ACTIVATE (1422), and AUDIT_TRUST_STATUS (1423) have this
form:

AUDIT1421 IPE policy_name="my-policy" policy_version=0.0.0 
<hash_alg_name>=<hash>
AUDIT1422 IPE policy_name="my-policy" policy_version=0.0.0 
<hash_alg_name>=<hash>
AUDIT1423 IPE enforce=1

The 1421 (AUDIT_TRUST_POLICY_LOAD) event represents a new policy was loaded
into the kernel, but not is not marked as the policy to enforce. The

The 1422 (AUDIT_TRUST_POLICY_ACTIVATE) event represents a policy that was
already loaded was made the enforcing policy.

The 1423 (AUDIT_TRUST_STATUS) event represents a switch between 
permissive and
enforce, it is added in 08/16 (the following patch)

